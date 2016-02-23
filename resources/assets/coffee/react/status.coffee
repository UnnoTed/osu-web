###
# Copyright 2015 ppy Pty. Ltd.
#
# This file is part of osu!web. osu!web is distributed with the hope of
# attracting more community contributions to the core ecosystem of osu!.
#
# osu!web is free software: you can redistribute it and/or modify
# it under the terms of the Affero GNU General Public License version 3
# as published by the Free Software Foundation.
#
# osu!web is distributed WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with osu!web.  If not, see <http://www.gnu.org/licenses/>.
###
{div, span, br, strong, h1, h4, h5} = React.DOM
el = React.createElement

class @Status.Main extends React.Component
  constructor: (props) ->
    super props

    @state = 
      status: window.osuStatus
      # mode
      graph: 'users' # users or score
      uptime: 'today' # today, week, month, all_time
      incidents: 'today' # today, last_week, 2_weeks, 3_weeks

  componentDidMount: =>
    @_rankHistory()
    @_map()
    @_charts()

  componentDidUpdate: =>
    @_rankHistory()
    @_charts()

  _changeViewMode: (mode, time, e) ->
    s = {}
    s[mode] = time
    @setState(s)

  _charts: ->
    if _.isEmpty(@charts)
      @charts = {}      
      @charts.server = new Status.Chart(@refs.serverChart, 'server')
      @charts.web = new Status.Chart(@refs.webChart, 'web')

    @charts.server.set(@state.status.uptime.graphs.server[@state.uptime])
    @charts.web.set(@state.status.uptime.graphs.web[@state.uptime])

  _map: ->
    @map = new Status.Map(@refs.map, @state.status.servers)

  _yAxisTickValues: (data) ->
    rankRange = d3.extent data, (d) => d.y
    @_allTicks = [1, 2.5, 5]

    while _.last(@_allTicks) <= _.last(rankRange)
      @_allTicks.push (10 * @_allTicks[@_allTicks.length - 3])

    ticks = [@_allTicks[0]]
    for tick in @_allTicks
      tick = Math.trunc(tick)
      if tick < rankRange[1]
        ticks[0] = tick
      else
        ticks.push tick
        break if tick < rankRange[0]
    if ticks[0] != 0
      ticks.unshift(0)
    ticks

  _rankHistory: ->
    if _.isEmpty(@state.status.online.graphs.online) && _.isEmpty(@state.status.online.graphs.score)
      return

    data = []
    if @state.graph == 'users'
      data = @state.status.online.graphs.online
    else if @state.graph == 'score'
      data = @state.status.online.graphs.score

    data = data.map (players, j) =>
      x: j - data.length + 1
      y: players

    unless @_rankHistoryChart
      tickValues =
        x: [-12, -9, -6, -3, 0]

      domains =
        x: d3.extent(tickValues.x)

      formats =
        x: (d) =>
          if d == 0
            Lang.get('common.time.now')
          else
            Lang.choice('common.time.hours_ago', -d)
        y: (d) => 
          (d).toLocaleString()

      tooltipFormats =
        x: (d) =>
          "#{formats.x(d)}"

      scales =
        x: d3.scale.linear()
        y: d3.scale.linear()

      options =
        formats: formats
        tooltipFormats: tooltipFormats
        scales: scales
        tickValues: tickValues
        domains: domains

      @_rankHistoryChart = new LineChart(@refs.chartArea, options)
      @_rankHistoryChart.margins.bottom = 65
      @_rankHistoryChart.xAxis.tickPadding 5

      $(window).on 'throttled-resize.profilePagePerformance', @_rankHistoryChart.resize

    yTickValues = @_yAxisTickValues data
    @_rankHistoryChart.options.tickValues.y = yTickValues
    @_rankHistoryChart.options.domains.y = d3.extent(yTickValues)
    @_rankHistoryChart.loadData(data)

  render: =>
    status = @state.status

    activeIncidents = false
    status.incidents.map (incident) =>
      if incident.active
        activeIncidents = true

    incidents = status.incidents.map (incident, id) =>
      ok = false
      if @state.incidents == 'today' && moment().isSame(moment(incident.date, 'DD-MM-YYYY'), 'days')
        ok = true
      else if @state.incidents == 'last_week' && moment(incident.date, 'DD-MM-YYYY').isBetween(moment().subtract(1, 'week'), moment())#moment().isSame(moment(incident.date, 'DD-MM-YYYY'), 'week')
        ok = true
      else if @state.incidents == '2_weeks' && moment(incident.date, 'DD-MM-YYYY').isBetween(moment().subtract(2, 'weeks'), moment().subtract(1, 'week'))
        ok = true
      else if @state.incidents == '3_weeks' && moment(incident.date, 'DD-MM-YYYY').isBetween(moment().subtract(3, 'weeks'), moment().subtract(2, 'weeks'))
        ok = true

      if ok
        el Status.Incident,
          key: id
          Description: incident.description
          Active: incident.active
          Status: incident.status
          Date: incident.date
          By: incident.by

    div 
      id: 'statusPage'
      className: 'status osu-layout__row'
      div className: 'status__header',
        span className: 'logo',
          null
        div className: 'text',
          h1 null,
            strong null,
              ['osu!']
            Lang.get("statusPage.header.title")
          h4 null,
            Lang.get('statusPage.header.description')
      br
      br
      div className: 'status__incidents osu-layout__row--page-compact' + (if activeIncidents then '' else ' hidden'),
        h1 null,
          Lang.get('statusPage.incidents.title')
        div className: 'incidents__list',
          status.incidents.map (incident, id) =>
            if incident.active
              el Status.Incident,
                key: id
                Description: incident.description
                Active: incident.active
                Status: incident.status
                Date: incident.date
                By: incident.by
      div
        ref: 'map'
        className: 'status__map osu-layout__row--page-compact'
      div className: 'status__online osu-layout__row--page-compact',
        h1 null,
          (if @state.graph == 'users' then Lang.get('statusPage.online.title.users') else Lang.get('statusPage.online.title.score'))
        div
          ref: 'chartArea'
          className: 'chart'
        div className: 'online__info',
          div className: 'border',
            null
          div 
            className: 'info__users' + (if @state.graph == 'users' then ' active' else '')
            onClick: @_changeViewMode.bind(@, 'graph', 'users')
            h4 null,
              Lang.get('statusPage.online.current')
            h1 null,
              @state.status.online.current
          div className: 'separator',
            null
          div 
            className: 'info__score' + (if @state.graph == 'score' then ' active' else '')
            onClick: @_changeViewMode.bind(@, 'graph', 'score')
            h4 null,
              Lang.get('statusPage.online.score')
            h1 null,
              @state.status.online.score
      div className: 'status__recent',
        div className: 'recent__incidents osu-layout__row--page-compact',
          h1 null,
            Lang.get('statusPage.recent.incidents.title')
          div className: 'incidents__when',
            h5
              onClick: @_changeViewMode.bind(@, 'incidents', 'today')
              className: 'active' unless @state.incidents != 'today'
              Lang.get('statusPage.recent.when.today')
            h5 
              onClick: @_changeViewMode.bind(@, 'incidents', 'last_week')
              className: 'active' unless @state.incidents != 'last_week'
              Lang.get('statusPage.recent.when.last_week')
            h5 
              onClick: @_changeViewMode.bind(@, 'incidents', '2_weeks')
              className: 'active' unless @state.incidents != '2_weeks'
              Lang.choice('statusPage.recent.when.weeks_ago', 2)
            h5 
              onClick: @_changeViewMode.bind(@, 'incidents', '3_weeks')
              className: 'active' unless @state.incidents != '3_weeks'
              Lang.choice('statusPage.recent.when.weeks_ago', 3)
          div className: 'incidents__list',
            incidents
        div className: 'recent__uptime osu-layout__row--page-compact',
          h1 null,
            Lang.get('statusPage.recent.uptime.title')
          div className: 'uptime__when',
            h5
              onClick: @_changeViewMode.bind(@, 'uptime', 'today')
              className: 'active' unless @state.uptime != 'today'
              Lang.get('statusPage.recent.when.today')
            h5 
              onClick: @_changeViewMode.bind(@, 'uptime', 'week')
              className: 'active' unless @state.uptime != 'week'
              Lang.get('statusPage.recent.when.week')
            h5 
              onClick: @_changeViewMode.bind(@, 'uptime', 'month')
              className: 'active' unless @state.uptime != 'month'
              Lang.get('statusPage.recent.when.month')
            h5 
              onClick: @_changeViewMode.bind(@, 'uptime', 'all_time')
              className: 'active' unless @state.uptime != 'all_time'
              Lang.get('statusPage.recent.when.all_time')
          div className: 'uptime__charts',
            div
              ref: 'serverChart'
              className: 'charts__server'
            div
              ref: 'webChart'
              className: 'charts__web'

ReactDOM.render el(Status.Main), document.getElementsByClassName('js-content')[0]


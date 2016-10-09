###
# Copyright 2016 ppy Pty. Ltd.
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
{div, p} = React.DOM
el = React.createElement

class @Changelog.Page extends React.Component
  constructor: (props) ->
    super props

    @state = 
      changelog: window.changelogData

  componentDidMount: =>
    @_chart()

  componentDidUpdate: =>
    @_chart()

  _chart: =>
    if _.isEmpty(@logChart)
      @logChart = new ChangelogChart(@refs.logChart, @state.changelog)

    @state.changelog.map (l) =>
      name = Changelog.utils.fixName(l.name)
      @logChart.setArea(name, l.chart)

  setBackground: (name) =>
    logs = {}
    @state.changelog.map (l) =>
      console.log(l);
      if Changelog.utils.fixName(l.name) == name
        logs = l.logs

    @setState =>
      bg: name
      logs: logs

  render: =>
    bg = if @state.bg then "changelog-header--#{@state.bg}" else ''
    changelog = @state.changelog

    div null,
      div className: "changelog-header osu-layout__row osu-layout__row--page #{bg}",
        div className: 'osu-layout__col osu-layout__col--sm-12',
          el Changelog.Buttons,
            setBackground: @setBackground
            buttons: changelog
      div 
        className: 'osu-layout__row changelog-chart__container'
        p className: 'changelog-chart__text',
          'Build Propagation Last Week (%)'
        div ref: 'logChart',
          null
      div className: 'osu-layout__row osu-layout__row--page',
        div className: 'osu-layout__col osu-layout__col--sm-12',
          el Changelog.Logs,
            logs: @state.logs

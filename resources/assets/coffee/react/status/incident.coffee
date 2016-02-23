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
{div, span} = React.DOM
el = React.createElement

class Status.Incident extends React.Component
  propTypes = 
    Description: React.PropTypes.string.isRequired
    Active : React.PropTypes.bool.isRequired
    Status: React.PropTypes.string.isRequired
    Date: React.PropTypes.string.isRequired
    By: React.PropTypes.string.isRequired

  constructor: (props) ->
    super props

  render: =>
    fromNow = moment(@props.Date, 'DD-MM-YYYY HH:mm:ss').fromNow()

    div 
      className: 'incident'
      div 
        className: 'incident__state incident__state--' + @props.Status
      div 
        className: 'incident__content'
        div 
          className: 'info'
          span className: 'info__date',
            fromNow + ', ' 
          span className: 'info__by',
            if _.isEmpty(@props.By) then 'automated' else 'by ' + @props.By
        div 
          className: 'desc'
          span 
            className: 'active' unless !@props.Active
            @props.Description
          span
            ' ' + Lang.get('statusPage.recent.incidents.state.' + @props.Status) + '!'

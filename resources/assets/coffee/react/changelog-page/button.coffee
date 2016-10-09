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
{div, h6, h4, p} = React.DOM

class Changelog.Button extends React.Component
  propTypes = 
    onClick: React.PropTypes.string.isRequired
    version: React.PropTypes.string.isRequired
    active: React.PropTypes.bool.isRequired
    color: React.PropTypes.string.isRequired
    users: React.PropTypes.string.isRequired
    name: React.PropTypes.string.isRequired
    size: React.PropTypes.string.isRequired

  constructor: (props) ->
    super props

  render: =>
    sizeClass = if @props.size then "changelog-button--#{@props.size}" else ''
    css = "changelog-button changelog-button--#{@props.color} #{sizeClass}"
    css += ' changelog-button--active' if @props.active == true

    div 
      onClick: @props.onClick
      className: css
      h6 className: 'changelog-button__name',
        @props.name
      h4 className: 'changelog-button__version',
        @props.version
      p className: 'changelog-button__users',
        "#{@props.users} users online"
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
{div, h1, h5} = React.DOM
el = React.createElement

class Changelog.Buttons extends React.Component
  constructor: (props) ->
    super props
    @state =
      buttons: props.buttons

  componentDidMount: =>
    # select the first button
    if @props.buttons
      @select(0, @props.buttons[0].name)

  select: (id, name) =>
    @setState =>
      active: id
    @props.setBackground(Changelog.utils.fixName(name))

  render: =>
    buttons = @state.buttons.map (l, id) =>
      el Changelog.Button,
        key: id
        onClick: =>
          @select(id, l.name)
        version: l.version
        active: @state.active == id
        color: l.color
        users: (l.users || 0)
        name: l.name
        size: (l.size || '')

    div className: 'changelog-button__container',
      buttons

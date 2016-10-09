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
{div, h2, h5, a, i} = React.DOM
el = React.createElement

class Changelog.Logs extends React.Component
  constructor: (props) ->
    super props

  fromList: (list) =>
    logs = []
    id = 0 # avoid error
    for date of list
      logs.push div key: id,
        h2 className: 'changelog-logs__date',
          date
        @fromDate(list[date])
      id++
    logs

  fromDate: (date) =>
    group = []
    id = 0 # avoid error
    for version in _.keysIn(date)
      group.push div key: id,
        h5 className: 'changelog-logs__version',
          version
        @fromVersion(date[version])
      id++
    group

  fromVersion: (version) =>
    version_list = []
    id = 0 # avoid error
    for log in version
      icon = if log.type == 'fix' then 'wrench' else 'plus'
      version_list.push div 
        key: id,
        className: 'changelog-logs__log',
        div className: 'changelog-logs__log-author',
          i className: "changelog-logs__log-icon fa fa-#{icon}",
            null
          a null,
            log.author
        div className: 'changelog-logs__log-text',
          log.text
      id++
    version_list


  render: =>
    if _.isEmpty(@props.logs)
      return div null,
        'CALL PEPPY, NO LOGS AVAILABLE!'
    div className: 'changelog-logs',
      @fromList(@props.logs)

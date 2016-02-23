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

class Status.Chart
  constructor: (element, name) ->
    @pi = 2 * Math.PI
    width = $(element).width()
    height = $(element).height()
    outerRadius = Math.min(width, height) / 2
    innerRadius = outerRadius / 4.7 * 4
    fontSize = Math.min(width, height) / 10

    @arc = d3.svg
            .arc()
            .innerRadius(innerRadius)
            .outerRadius(outerRadius)
            .startAngle(0)

    @svg = d3.select(element)
            .append('svg')
            .attr('width', '100%')
            .attr('height', '100%')
            .attr('viewBox', '0 0 ' + Math.min(width, height) + ' ' + Math.min(width, height))
            .attr('preserveAspectRatio', 'xMinYMin')
            .append('g')
            .attr('transform', 'translate(' + Math.min(width, height) / 2 + ',' + Math.min(width, height) / 2 + ')')

    @text = @svg.append('text')
              .text(name)
              .attr('text-anchor', 'middle')
              .style('font-size', fontSize + 'px')
              .attr('dy', -(fontSize/5))
              .attr('dx', 2)
    
    @percentage = @svg.append('text')
                    .attr('text-anchor', 'middle')
                    .style('font-size', fontSize + 'px')
                    .attr('dy', fontSize / 1)
                    .attr('dx', 2)
                    .style('fill', '#c20775')

    @background = @svg.append('path')
                    .datum(endAngle: @pi)
                    .style('fill', '#ffcc00')
                    .attr('d', @arc)

    @greenForeground = @svg.append('path')
                         .attr("class", "green_line")
                         .datum(endAngle: parseFloat('0.' + 0) * @pi)
                         .style('fill', '#a0cc00')
                         .attr('d', @arc)

    @redForeground = @svg.append('path')
                       .attr("class", "red_line")
                       .datum(endAngle: (parseFloat('-0.' + 0) * @pi))
                       .style('fill', '#ff65ac')
                       .attr('d', @arc)

  parse: (n) ->
    n = Number(n)
    if n < 10
      n = '0' + n

    if n == 100
      return parseFloat('1.0') * @pi
    else
      return parseFloat('0.' + n) * @pi

  set: (data) ->
    _this = @
    arcTween = (transition, newAngle, percentage) ->
      transition.attrTween 'd', (d) ->
        interpolate = d3.interpolate(d.endAngle, newAngle)
        (t) ->
          d.endAngle = interpolate(t)
          if percentage
            _this.percentage.text percentage + '%'
          _this.arc d
      return

    r = -@parse(data.down)

    @redForeground.transition().duration(750).call(arcTween, r, null)
    @greenForeground.transition().duration(750).call(arcTween, @parse(data.up), data.up)

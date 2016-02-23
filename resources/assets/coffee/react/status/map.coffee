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

class Status.Map
  constructor: (element, servers) ->
    growers = []
    offset = 40
    @width = $(element).width()
    @height = (@width*9.3/21)
    $(element).height(@height)
    force = d3.layout.force()

    @maxWidth = 1350
    @maxHeight = 597
    fontSize = 17

    colors =
      up: '#acd300'
      down: '#ff0000'

    svg = d3.select(element)
            .append('svg')
            .attr("width", '100%')
            .attr("height", '100%')
            .attr('viewBox','0 0 ' + @width + ' ' + (@height - offset))
            .attr('preserveAspectRatio','xMinYMin')

    g = svg.append('g')
           .attr("transform", "translate(" + 0 + "," + 0 + ")")

    img = g.append('svg:image')
           .attr('xlink:href', '../images/backgrounds/world_map.svg')
           .attr('width', '100%')
           .attr('height', '100%')
           .attr('x', 0)
           .attr('y', offset / 2)

    # inserts each circle + name and player number
    for server in servers
      svg.append('ellipse')
         .attr('rx', @scale('height', 8))
         .attr('ry', @scale('height', 8))
         .attr('cx', @scale('width', server.x))
         .attr('cy', @scale('height', server.y))
         .style('fill', 'none')
         .attr('stroke-miterlimit', 0)
         .attr('stroke-width', @scale('height', 5))
         .attr('stroke', colors[server.state])

      # the "O" that grows
      grower = svg.append('ellipse')
                  .attr('rx', @scale('height', 8))
                  .attr('ry', @scale('height', 8))
                  .attr('cx', @scale('width', server.x))
                  .attr('cy', @scale('height', server.y))
                  .style('fill', 'none')
                  .attr('stroke-miterlimit', 0)
                  .attr('stroke-width', @scale('height', 5))
                  .attr('stroke', colors[server.state])

      ghg = @scale('height', 28)
      gho = @scale('height', 8)
      grower.on 'mouseover', ->
        d3.select(this)
          .transition()
          .duration(1000)
          .attr('rx', ghg)
          .attr('ry', ghg)
          .style('opacity', 0).each 'end', (->
            d3.select(this)
              .transition()
              .duration(1)
              .attr('rx', gho)
              .attr('ry', gho)
              .style('opacity', 1)
          )

      svg.append('text')
         .text(server.name)
         .attr('x', @scale('width', server.x))
         .attr('y', @scale('height', server.y - 40))
         .attr('fill', 'white')
         .attr('text-anchor', 'middle')
         .style('font-size', @scale('height', fontSize))

      svg.append('text')
         .text(server.players + ' players ' + (if server.state == 'down' then 'offline' else 'online'))
         .attr('x', @scale('width', server.x))
         .attr('y', @scale('height', server.y - 20))
         .attr('fill', 'white')
         .attr('text-anchor', 'middle')
         .style('font-size', @scale('height', fontSize))

    # resize map's view
    resize = () ->
      width = $(element).width()
      height = (width*9.3/21)
      $(element).height(height)
      force.size([width, height]).resume()
      return

    d3.select(window).on('resize', resize)

  scale: (b, val) ->
    actual = if b == 'width' then @width else @height
    max = if b == 'width' then @maxWidth else @maxHeight
    actual / (max / val)
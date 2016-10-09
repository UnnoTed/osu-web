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



class @ChangelogChart
  constructor: (element, data) ->
    @width = 1000#$(element).width()
    @height = 100#$(element).height()

    # map all user count into a array 
    # to get the highest user count
    chartLines = []
    data.map (i) ->
      chartLines.push i.chart
    @highest = d3.max _.flattenDeep(chartLines), (d) -> return d.users

    @svg = d3.select(element)
        .append('svg')
        .classed('changelog-chart__chart', true)
        .attr('width', '100%')
        .attr('height', '100%')
        .attr('viewBox', "0 0 #{@width} #{@height}")
        .attr('preserveAspectRatio','xMidYMin')
        .append('g')

    @x = d3.time.scale().range([0, @width])
    @y = d3.scale.linear().range([@height, 0])
    @area = d3.svg.area()
      .x((d) => @x(d.date))
      .y0(@height)
      .y1((d) => @y(d.users))

    @parseDate = d3.time.format("%d-%m-%Y %X").parse
    @vLine = d3.select(element).append('div').classed('changelog-chart__line', true)
    @info = d3.select(element).append("div").classed('changelog-chart__info', true)


    d3.select(element)
      .on "mousemove", (d) =>
        m = d3.mouse(d3.event.target)
        left = m[0] + 8
        top = m[1] + 10

        @vLine.style("left", "#{left}px")
        @info
          .style("left", "#{left}px")
          .style("top", "#{top}px")

  id: (name, hash) =>
    "#{if hash then '#' else ''}changelog-chart__#{name}"

  style: (name) =>
    "changelog-chart__area--#{name}"

  html: (d) =>
    date = moment(d.date).format("YYYY/MM/DD")
    date = "<div class=changelog-chart__info-date>#{date}</div>"
    users = "<div class=changelog-chart__info-users>#{d.users}</div>"

    users + date

  setArea: (name, data) =>
    if !d3.select(@id(name, true)).empty()
      return

    data.forEach (d) =>
      d.date = @parseDate d.date
      d.users = +d.users

    console.log('d', data, @highest)
    @x.domain(d3.extent(data, (d) -> d.date))
    @y.domain([0, d3.max(data, (d) => @highest)])

    # exists
    ###if !d3.select(@id(name, true)).empty()
      console.log('lmao')
      return d3.select(@id(name, true))
        .datum(data)
        .attr('d', area)###

    path = @svg.append('path')
       .classed(@style(name), true)
       .datum(data)
       .attr('id', @id(name))
       .attr('d', @area)

    @svg.selectAll("area")
        .data(data)
        .enter()
        .append("circle")
        .classed('changelog-chart__circle', true)
        .attr("cx", (d) => @x(d.date))
        .attr("cy", (d) => @y(d.users))
        .on "mouseover", (d) =>
          m = d3.mouse(d3.event.target)
          left = m[0]
          top = m[1]

          @vLine.style("left", "#{left}px")
          @info
            .style("left", "#{left}px")
            .style("top", "#{top}px")
            .html(@html(d))

    console.log('ayy')

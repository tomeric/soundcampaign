$.fn.barChart = ->
  this.each ->
    container = $ this
    table     = container.find('table')
    
    # Create the dataset:
    dataset = []
    table.find('tr').each ->
      row = $ this
      
      monthName = $.trim row.find('.month-name').text()
      monthDay  = parseInt $.trim(row.find('.month-day').text())
      value     = parseInt $.trim(row.find('.value').text())
      colour    = row.css('color')
      
      data = [value, monthDay, colour]
      data.push monthName if monthName.length > 0
      dataset.push data
    
    # Hide the data:
    table.css('display', 'none')
    
    # Create the SVG element:
    svg = d3.select(container.get(0))
            .append('svg')
            .attr(  'class', 'graph')
    
    width  = $(svg[0]).width()
    height = $(svg[0]).height()
    
    # Set the dimensions:
    svg.attr('height', width)
    svg.attr('width',  height)
    
    # Create scaling functions:
    xScale = d3.scale.ordinal()
               .domain(d3.range(dataset.length))
               .rangeRoundBands([0, width], 0.15)
    
    yScale = d3.scale.linear()
               .domain([0, d3.max(dataset, (d) -> d[0])])
               .range([0, (height - 60)])
    
    # Create bars:
    bar = svg.selectAll('rect')
             .data(dataset)
             .enter()
             .append('rect')
             .attr('x',      (d, i) -> xScale(i))
             .attr('y',      (d   ) -> height - yScale(d[0]) - 36)
             .attr('width',  xScale.rangeBand())
             .attr('height', (d   ) -> yScale(d[0]))
             .attr('fill',   (d   ) -> d[2])
    
    # Tooltip:
    tooltipId = "tooltip#{Math.round(new Date().getTime() + (Math.random() * 100))}"
    bar.on('mouseover', (d) ->
      # Get this bar's x/y values, then augment for the tooltip
      xPosition = parseFloat(d3.select(this).attr('x')) + xScale.rangeBand() / 2
      yPosition = parseFloat(d3.select(this).attr('y')) - 8
      
      # Create tooltip label:
      svg.append('text')
         .text(d[0])
         .attr('id', tooltipId)
         .attr('x',  xPosition)
         .attr('y',  yPosition)
         .attr('text-anchor', 'middle')
         .attr('font-family', 'sans-serif')
         .attr('font-size',   '14px')
         .attr('font-weight', 'bold')
         .attr('fill',        '#00a3fb')
    ).on('mouseout', ->
      d3.select("##{tooltipId}").remove()
    )

    # text label voor dag
    svg.selectAll("text.days")
       .data(dataset)
       .enter()
       .append("text")
       .text((d) -> d[1])
       .attr("fill", (d) -> d[2])
       .attr("x", (d, i) -> xScale(i) + (width / dataset.length) - (dataset.length) + 8)
       .attr("y", (d   ) -> height - 20)
       .attr("text-anchor", "left")
       .attr("font-family", "sans-serif")
       .attr("font-size",   "11px")
          
    # text label voor maand
    svg.selectAll("text.month")
       .data(dataset)
       .enter()
       .append("text")
       .text((d) -> d[3])
       .attr("fill", (d) -> d[2])
       .attr("x", (d, i) -> xScale(i))
       .attr("y", (d   ) -> height - 3)
       .attr("text-anchor", "left")
       .attr("font-family", "sans-serif")
       .attr("font-size",   "12px")


$(document).ready ->
  $('.d3-bar-chart').barChart()
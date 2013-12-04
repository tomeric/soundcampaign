window.SC ||= {}
class SC.Waveform
  constructor: (@wrapper, data) ->
    @data  = data.filter (date, index) -> index % 1 == 0
    @graph = d3.select(@wrapper.get(0))
               .append('svg')
    
    @initializeGraph()
    
  initializeGraph: ->
    @width  = @wrapper.width()
    @height = @wrapper.height()
    
    @graph.attr('viewBox', "0 0 #{@width} #{@height}")
          .attr('preserveAspectRatio', 'none')
    
    @graph.selectAll('rect')
          .data(@data.map (date) => date * @height / 2.7)
          .enter()
          .append('rect')
          .attr('x', (d, i) => i * (@width / @data.length))
          .attr('y', (d   ) => (@height / 2) - d)
          .attr('width', '1px')
          .attr('height', (d) => d * 2)
          .attr('fill', @wrapper.data('fill-color'))
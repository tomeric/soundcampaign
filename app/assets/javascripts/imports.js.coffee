$(document).ready ->
  $(document).on 'change', '#import input#first_row_header', ->
    checkbox = $ this
    tr       = checkbox.parents('tr')
    table    = tr.parents('table')
    
    if checkbox.prop('checked')
      thead = table.find('thead')
      tr.find('td:not(.header-check)').replaceWith -> "<th>#{$(this).html()}</th>"
      tr.appendTo thead
    else
      tbody = table.find('tbody')
      tr.find('th').replaceWith -> "<td>#{$(this).html()}</td>"
      tr.prependTo tbody
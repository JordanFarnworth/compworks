# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.companies .index').ready ->
  $('.navbar').show()
  $('#company-name-search').autocomplete autocompleteCompanyNameParams()

autocompleteCompanyNameParams = ->
  {
    source:(request, response) ->
      $.ajax
        url: "/api/v1/companies",
        dataType: "json"
        data:
          search_term: request.term
        success: (data) ->
          data = $.map data, (obj, i) ->
            {label: obj.name, value: obj.id, obj: obj}
          response data

    select:(event, ui) ->
      event.prevent_default
  }

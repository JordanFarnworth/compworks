# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('.purchase_orders.new').ready ->
  $('#client-input').autocomplete autocompleteCompanyNameParams()
  $('#vendor-input').autocomplete autocompleteVendorParams()
  $('#item-input').autocomplete autocompleteItemParams()
  $('#po-submit').on 'click', ->
    createNewPo()

createNewPo = ->
  $.ajax '/purchase_orders',
  type: 'post',
  dataType: 'json',
  data:
    purchase_order:
      company_id: $('#client-input').attr('data-id')
      vendor: $('#vendor-input').val()
      item:   $('#item-input').val()
      payment: $('#received-input').prop('checked')
  success: (data) ->
    bootbox.alert "Purchase Order ##{data.po_number} was created", ->
      window.location = "/purchase_orders/#{data.id}"


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
            {label: "#{obj.name} (#{obj.doctor_name})", value: obj.id, obj: obj}
          response data

    select:(event, ui) ->
      event.preventDefault()
      id = ui.item.value
      name = ui.item.obj.name
      $(@).val(name)
      $(@).attr('data-id', id)
      console.log this
  }

autocompleteVendorParams = ->
  {
    source:(request, response) ->
      $.ajax
        url: "/api/v1/vendor_search",
        dataType: "json"
        data:
          search_term: request.term
        success: (data) ->
          data = $.map data, (obj, i) ->
            {label: "#{obj.name}", value: obj.id, name: obj.name}
          response data

    select:(event, ui) ->
      event.preventDefault()
      id = ui.item.value
      name = ui.item.name
      $(@).val(name)
      $(@).attr('data-id', id)
      console.log this
  }

autocompleteItemParams = ->
  {
    source:(request, response) ->
      $.ajax
        url: "/api/v1/item_search",
        dataType: "json"
        data:
          search_term: request.term
        success: (data) ->
          data = $.map data, (obj, i) ->
            {label: "#{obj.name}", value: obj.id, name: obj.name}
          response data

    select:(event, ui) ->
      event.preventDefault()
      id = ui.item.value
      name = ui.item.name
      $(@).val(name)
      $(@).attr('data-id', id)
      console.log this
  }
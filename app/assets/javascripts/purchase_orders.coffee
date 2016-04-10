# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('.purchase_orders.new').ready ->
  $('#client-input').autocomplete autocompleteCompanyNameParams()
  $('#vendor-input').autocomplete autocompleteVendorParams()
  $('#item-input').autocomplete autocompleteItemParams()
  $('#po-submit').on 'click', ->
    createNewPo()

$('.purchase_orders.edit').ready ->
  $('#client-input-edit').autocomplete autocompleteCompanyNameParams()
  $('#vendor-input-edit').autocomplete autocompleteVendorParams()
  $('#item-input-edit').autocomplete autocompleteItemParams()
  $('#po-update').on 'click', ->
    updatePo()
  loadPoParams()

$('.purchase_orders.show').ready ->
  $('#delete-purchase-order').on 'click', ->
    deletePo()

$('.purchase_orders.index').ready ->
  bindPoButtons()

bindPoButtons = ->
  $('.mark-received').on 'click', ->
    markPoAsRecieved($(this).attr('data-id'))
  $('.mark-unreceived').on 'click', ->
    markPoAsUnRecieved($(this).attr('data-id'))

markPoAsRecieved = (poId) ->
  $.ajax "/api/v1/mark_po_as_received",
    type: 'post',
    dataType: 'json',
    data:
      id: poId
    success: (data) ->
      bootbox.alert "PO \##{data.po_number} was markd as received", ->
        location.reload()

markPoAsUnRecieved = (poId) ->
  $.ajax "/api/v1/mark_po_as_unreceived",
    type: 'post',
    dataType: 'json',
    data:
      id: poId
    success: (data) ->
      bootbox.alert "PO \##{data.po_number} was markd as unreceived", ->
        location.reload()

loadPoParams = ->
  po = window.location.pathname.match(/\/purchase_orders\/(\d+)/)[1]
  $.ajax "/api/v1/purchase_orders/#{po}",
    type: 'get',
    dataType: 'json',
    success: (data) ->
      populateForm(data)

populateForm = (data) ->
  $('#po-number-edit').append("<h1>\##{data.po_number}</h1>")
  if data.payment
    $('#received-input-edit').prop('checked', true)
  else
  $('#received-input-edit').prop('checked', false)
  $('#client-input-edit').val(data.company.name)
  $('#client-input-edit').attr('data-id', data.company.id)
  $('#vendor-input-edit').val(data.vendor[0].name)
  $('#item-input-edit').val(data.items[0].name)
  $('#current-image').append("<img src=\"#{data.image}\" />")

createNewPo = ->
  $.ajax '/purchase_orders',
    type: 'post',
    dataType: 'json',
    contentType: false,
    processData: false,
    data: buildRequestData()
    success: (data) ->
      bootbox.alert "Purchase Order ##{data.po_number} was created", ->
        window.location = "/purchase_orders/#{data.id}"

updatePo = ->
  po = window.location.pathname.match(/\/purchase_orders\/(\d+)/)[1]
  $.ajax "/purchase_orders/#{po}",
    type: 'put',
    dataType: 'json',
    contentType: false,
    processData: false,
    data: buildUpdateRequestData()
    success: (data) ->
      bootbox.alert "Purchase Order ##{data.po_number} was updated", ->
        window.location = "/purchase_orders/#{data.id}"

deletePo = ->
  po = window.location.pathname.match(/\/purchase_orders\/(\d+)/)[1]
  bootbox.confirm "Are you sure you want to delete this PO?", (response) ->
    if response then deletePoFrd(po) else null

deletePoFrd = (po) ->
  $.ajax "/api/v1/purchase_orders/#{po}",
    type: 'delete',
    dataType: 'json',
    success: (data) ->
      bootbox.alert "Purchase Order ##{data.po_number} was deleted!", ->
        window.location = "/purchase_orders/new"

buildUpdateRequestData = ->
  formData = new FormData()
  formData.append 'purchase_order[company_id]', $('#client-input-edit').attr('data-id')
  formData.append 'purchase_order[vendor]', $('#vendor-input-edit').val()
  formData.append 'purchase_order[item]', $('#item-input-edit').val()
  formData.append 'purchase_order[payment]', $('#received-input-edit').prop('checked')
  if $('#InputFile').val() then formData.append 'purchase_order[image]', $('#InputFile')[0].files[0] else null
  formData


buildRequestData = ->
  formData = new FormData()
  formData.append 'purchase_order[company_id]', $('#client-input').attr('data-id')
  formData.append 'purchase_order[vendor]', $('#vendor-input').val()
  formData.append 'purchase_order[item]', $('#item-input').val()
  formData.append 'purchase_order[payment]', $('#received-input').prop('checked')
  formData.append 'purchase_order[image]', $('#InputFile')[0].files[0]
  formData


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
  }

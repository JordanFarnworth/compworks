## SL = Service Log && II = Inventory Item

$('.companies.index').ready ->
  #autocomplete inititalize
  $('#company-name-search').autocomplete autocompleteCompanyNameParams()
  $('#undelete-company-name-search').autocomplete autocompleteUndeleteCompanyNameParams()
  $('#restore-company-link').on 'click', ->
    $('#restore-company-div').toggleClass("hide")
    $('#company-search-div').toggleClass("hide")

#autocomplete for restoring deleted companies
autocompleteUndeleteCompanyNameParams = ->
  {
    source:(request, response) ->
      $.ajax
        url: "/api/v1/undelete",
        dataType: "json"
        data:
          search_term: request.term
        success: (data) ->
          data = $.map data, (obj, i) ->
            {label: "#{obj.name} (#{obj.doctor_name})", value: obj.id, obj: obj}
          response data

    select:(event, ui) ->
      event.preventDefault()
      bootbox.confirm "Are you sure you want to undelete #{ui.item.label}?", (result) ->
        if result == true
          undeleteCompany(ui.item.obj)

  }

#autocomplete function for finding companies
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
      window.location.pathname = "/companies/#{ui.item.value}"
  }

# companies page show page loads
$('.companies.show').ready ->
  #on modal close for II && SL && Company edit, unbind update button
  $('#edit-inventory-item-modal').on 'hide.bs.modal', ->
    $('#update-inventory-item').off 'click'
  $('#edit-service-log-modal').on 'hide.bs.modal', ->
    $('#update-service-log').off 'click'
  $('#edit-company-modal').on 'hide.bs.modal', ->
    $('#update-company').off 'click'
  #calling load functions when the page loads
  loadInventoryData()
  loadServiceLogData()
  loadCompanyData()
  #opening modals
  $('#add-inventory-item').on 'click', ->
    $('#inventory-item-modal').modal('show')
  $('#add-service-log').on 'click', ->
    $('#service-log-modal').modal('show')
  #initializing date picker
  $('#edit-input-date').on 'click', ->
    $('#edit-input-date').pickadate()
  $('#input-date').on 'click', ->
    $('#input-date').pickadate()
  #clear modal functions being binded
  $('#clear-service-log').on 'click', ->
    clearServiceLogModal()
  $('#clear-edit-service-log').on 'click', ->
    clearEditServiceLogModal()
  $('#clear-inventory-items-modal').on 'click', ->
    clearInventoryItemModal()
  $('#clear-edit-inventory-items-modal'). on 'click', ->
    clearEditInventoryItemModal()
  #create functions being called on click.
  #also adds SL's and II's to tables
  $('#create-service-log').on 'click', ->
    createServiceLog()
    clearServiceLogModal()
    $('#service-log-modal').modal('hide')
    $('#service-log-data').empty()
    loadServiceLogData()
  $('#create-inventory-item').on 'click', ->
    createInventoryItem()
    $('#inventory-item-modal').modal('hide')
    loadInventoryData()
  $('#restore-company-link').addClass('hide')

#undelete company
undeleteCompany = (company) ->
  $.ajax "/api/v1/companies/#{company.id}/undelete",
    type: "put"
    dataType: "json"
    data:
      company:
        state: "active"
    success: (data) ->
      bootbox.alert "#{data.name} has been reactivated"

#clear modal fields
clearServiceLogModal = ->
  $('#input-length').val("")
  $('#sp-text-area').val("")
  $('#notes-text-area').val("")
  $('#input-date').val("")

clearInventoryItemModal = ->
  $('#input-computer-name').val("")
  $('#input-hard-drive').val("")
  $('#input-operating-system').val("")
  $('#input-processor').val("")
  $('#input-ram').val("")
  $('#logmein-checkbox').prop('checked', false)

clearEditInventoryItemModal = ->
  $('#edit-computer-name').val("")
  $('#edit-hard-drive').val("")
  $('#edit-operating-system').val("")
  $('#edit-processor').val("")
  $('#edit-ram').val("")
  $('#edit-logmein-checkbox').prop('checked', false)

clearEditServiceLogModal = ->
  $('#edit-length').val("")
  $('#edit-sp-text-area').val("")
  $('#edit-notes-text-area').val("")
  $('#edit-input-date').val("")

clearEditCompanyModal = ->
  $('#edit-comp-name').val("")
  $('#edit-comp-doctor').val("")
  $('#edit-comp-network').val("")
  $('#edit-comp-domain').val("")
  $('#edit-comp-antivirus').val("")
  $('#edit-comp-router1').val("")
  $('#edit-comp-router2').val("")

#create functions
createServiceLog = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}/service_logs",
    type: "post"
    dataType: "json"
    data:
      service_log:
        date: $('#input-date').val()
        length: $('#input-length').val()
        service_preformed: $('#sp-text-area').val()
        notes: $('#notes-text-area').val()
        company_id: company
    success: (data) ->
      bootbox.alert 'Service Log Created', ->
        location.reload()

createInventoryItem = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}/inventory_items",
    type: "post"
    dataType: "json"
    data:
      inventory_item:
        company_id: company
        features:
          computer_name: $('#input-computer-name').val()
          processor: $('#input-processor').val()
          ram: $('#input-ram').val()
          hard_drive: $('#input-hard-drive').val()
          operating_system: $('#input-operating-system').val()
          log_me_in: $('#logmein-checkbox').prop('checked')
    success: (data) ->
      bootbox.alert 'Inventory Item Created', ->
        location.reload()

#load Company Data functions
loadCompanyData = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}",
    type: "get"
    dataType: "json"
    success: (data) ->
      showCompanyData(data)
      showCompanyTitle(data)
      populateCompanyModal(data)
      $('#edit-company-features').on 'click', ->
        $('#edit-company-modal').modal('show')
      $('#delete-company').on 'click', ->
        deleteCompany(data)
      $('#clear-comp-edit').on 'click', ->
        clearEditCompanyModal()
      $('#reset-comp-edit').on 'click', ->
        populateCompanyModal(data)
      $('#update-company').on 'click', ->
        updateCompany()

#show data from ^ load function
showCompanyData = (data) ->
  template = Handlebars.compile($("script#company-data").html())
  temp = $(template(data))
  $('#company-info').html(temp)

#company title at top of #show page
showCompanyTitle = (data) ->
  template = Handlebars.compile($("script#company-title").html())
  temp = $(template(data))
  $('#company-title').html(temp)

#load Inventory Data function
loadInventoryData = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}/inventory_items",
    type: "get"
    dataType: "json"
    success: (data) ->
      $('#inventory-data').empty()
      $.each data, ->
        addInventoryItemToTable(this)
        $("#delete-inventory-item-#{this.id}").on 'click', ->
          id = $(@).attr('name')
          deleteInventoryItem(id)
        $("#edit-inventory-item-#{this.id}").on 'click', ->
          id = $(@).attr('name')
          editInventoryItem(id)

#adds inventory data to the table
addInventoryItemToTable = (data) ->
  template = Handlebars.compile($("script#inventory-item-data").html())
  temp = $(template(data))
  $('#inventory-data').append(temp)
  if data.features.log_me_in == 'true'
    temp.find('.logmein').text('Yes')
  else if data.features.log_me_in == 'false'
    temp.find('.logmein').text('No')
  else
    temp.find('.logmein').text('?')

#load service log data
loadServiceLogData = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}/service_logs",
    type: "get"
    dataType: "json"
    success: (data) ->
      $('#service-log-data').empty()
      $.each data, ->
        addServiceLogToTable(this)
        $("#service-log-edit-#{this.id}").on 'click', ->
          id = $(@).attr('name')
          editServiceLog(id)
        $("#delete-service-log-#{this.id}").on 'click', ->
          id = $(@).attr('name')
          deleteServiceLog(id)


#add service log data to table
addServiceLogToTable = (service_log) ->
  service_log.date = new Date(service_log.date).toLocaleDateString()
  template = Handlebars.compile($("script#service-log-data").html())
  temp = $(template(service_log))
  $('#service-log-data').append(temp)

#add company info to the edit modal

populateCompanyModal = (company) ->
  $('#edit-comp-name').val(company.name)
  $('#edit-comp-doctor').val(company.doctor_name)
  $('#edit-comp-network').val(company.network)
  $('#edit-comp-domain').val(company.domain)
  $('#edit-comp-antivirus').val(company.antivirus)
  $('#edit-comp-router1').val(company.router1)
  $('#edit-comp-router2').val(company.router2)

#edit SL && II functions
editInventoryItem = (id) ->
  $('#edit-inventory-item-modal').modal('show')
  $('#edit-computer-name').val($("#ii-computer-name-#{id}").text())
  $('#edit-hard-drive').val($("#ii-hard-drive-#{id}").text())
  $('#edit-operating-system').val($("#ii-os-#{id}").text())
  $('#edit-processor').val($("#ii-processor-#{id}").text())
  $('#edit-ram').val($("#ii-ram-#{id}").text())
  $('#update-inventory-item').on 'click', ->
    updateInventoryItem(id)

editServiceLog = (id) ->
  $('#edit-service-log-modal').modal('show')
  $('#edit-length').val($("#sl-length-#{id}").text())
  $('#edit-sp-text-area').val($("#sl-sp-#{id}").text())
  $('#edit-notes-text-area').val($("#sl-notes-#{id}").text())
  $('#edit-was-date').html("Date was " + $("#sl-date-#{id}").text())
  $('#update-service-log').on 'click', ->
    if $('#edit-input-date').val() < 1
      $('#date-warning-here').addClass("has-error")
      $('#date-warning-label').text("Date can't be empty (need to enter again when editing service log)")
    updateServiceLog(id)

#update functions that call the API

updateCompany = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}",
    type: "put"
    dataType: "json"
    data:
      company:
        network: $('#edit-comp-network').val()
        domain: $('#edit-comp-domain').val()
        antivirus: $('#edit-comp-antivirus').val()
        router1: $('#edit-comp-router1').val()
        router2: $('#edit-comp-router2').val()
        name: $('#edit-comp-name').val()
        doctor_name: $('#edit-comp-doctor').val()
    success: (data) ->
      $('#edit-company-modal').modal('hide')
      loadCompanyData()
      bootbox.alert "#{data.name} updated"


updateInventoryItem = (id) ->
  $.ajax "/api/v1/inventory_items/#{id}",
    type: "put"
    dataType: "json"
    data:
      inventory_item:
        features:
          computer_name: $('#edit-computer-name').val()
          processor: $('#edit-processor').val()
          ram: $('#edit-ram').val()
          hard_drive: $('#edit-hard-drive').val()
          operating_system: $('#edit-operating-system').val()
          log_me_in: $('#edit-logmein-checkbox').prop('checked')
    success: (data) ->
      $('#edit-inventory-item-modal').modal('hide')
      loadInventoryData()
      bootbox.alert "Inventory Item ##{data.id} updated"

# #delete SL && II functions

deleteInventoryItem = (inventory_item) ->
  id = inventory_item.match(/(\d+)/)[1]
  bootbox.confirm 'Are you sure?', (result) ->
    if result == true
      $.ajax "/api/v1/inventory_items/#{id}",
        type: "delete"
        dataType: "json"
        success: () ->
          loadInventoryData()
          bootbox.alert 'Inventory Item Deleted'



deleteServiceLog = (service_log) ->
  id = service_log.match(/(\d+)/)[1]
  bootbox.confirm 'Are you sure?', (result) ->
    if result == true
      $.ajax "/api/v1/service_logs/#{id}",
        type: "delete"
        dataType: "json"
        success: () ->
          loadServiceLogData()
          bootbox.alert 'Service Log Deleted'

deleteCompany = (company) ->
  id = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  bootbox.confirm "Are you sure you want to delete #{company.name}?", (result) ->
    if result == true
      $.ajax "/api/v1/companies/#{id}",
        type: "delete"
        dataType: "json"
        success: () ->
          window.location.pathname = "/companies"

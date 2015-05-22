## SL = Service Log && II = Inventory Item

$('.companies.index').ready ->
  #autocomplete inititalize
  $('#company-name-search').autocomplete autocompleteCompanyNameParams()

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
  $('#input-date').on 'click', ->
    $('#input-date').pickadate()
  #clear modal functions being binded
  $('#clear-service-log').on 'click', ->
    clearServiceLogModal()
  $('#clear-inventory-items-modal').on 'click', ->
    clearInventoryItemModal()
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
    $('#inventory-data').empty()
    loadInventoryData()


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
      #add success modal here

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
          log_me_in: true if $('#logmein-checkbox').prop('checked', true)
    success: (data) ->
      #add success modal here

#load functions
loadCompanyData = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}",
    type: "get"
    dataType: "json"
    success: (data) ->
      showCompanyData(data)

showCompanyData = (data) ->
  template = Handlebars.compile($("script#company-data").html())
  temp = $(template(data))
  $('#company-info').html(temp)


loadInventoryData = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}/inventory_items",
    type: "get"
    dataType: "json"
    success: (data) ->
      $.each data, ->
        addInventoryItemToTable(this)
        addValueToEditModal(this)
        $("#delete-inventory-item-#{this.id}").on 'click', ->
          deleteInventoryItem(this.id)
        $("#edit-inventory-item-#{this.id}").on 'click', ->
          editInventoryItem(this.id)
          $('#edit-inventory-item-modal').modal('show')


addInventoryItemToTable = (data) ->
  #processInventoryItemData(data)
  template = Handlebars.compile($("script#inventory-item-data").html())
  temp = $(template(data))
  $('#inventory-data').append(temp)
  if data.features.log_me_in == true
    $('#logmein').text('Yes')
  else if data.features.log_me_in == false
    $('#logmein').text('No')
  else
    $('#logmein').text('?')


loadServiceLogData = ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  $.ajax "/api/v1/companies/#{company}/service_logs",
    type: "get"
    dataType: "json"
    success: (data) ->
      $.each data, ->
        addServiceLogToTable(this)
        $("#service-log-edit-#{this.id}").on 'click', ->
          editServiceLog(this.id)
          $('#edit-service-log-modal').modal('show')
        $("#delete-service-log-#{this.id}").on 'click', ->
          deleteServiceLog(this.id)



addServiceLogToTable = (service_log) ->
  service_log.date = new Date(service_log.date).toLocaleDateString()
  template = Handlebars.compile($("script#service-log-data").html())
  temp = $(template(service_log))
  $('#service-log-data').append(temp)

#edit SL && II functions
editInventoryItem = (data) ->
  company = window.location.pathname.match(/\/companies\/(\d+)/)[1]
  id = data.match(/(\d+)/)[1]
  $('#update-inventory-item').on 'click', ->
    console.log('edit')
    console.log("/api/v1/inventory_items/#{id}")
    # $.ajax "/api/v1/companies/#{company}/inventory_items",
    #   type: "put"
    #   dataType: "json"
    #   data:
    #     inventory_item:
    #       company_id: company
    #       features:
    #         computer_name: $('#edit-computer-name').val()
    #         processor: $('#edit-processor').val()
    #         ram: $('#edit-ram').val()
    #         hard_drive: $('#edit-hard-drive').val()
    #         operating_system: $('#edit-operating-system').val()
    #         log_me_in: true if $('#edit-logmein-checkbox').prop('checked', true)

editServiceLog = (data) ->
  id = data.match(/(\d+)/)[1]
  console.log('edit')
  console.log("/api/v1/service_logs/#{id}")

# #delete SL && II functions

deleteInventoryItem = (inventory_item) ->
  $('#delete-inventory-item-confirm').modal('show')
  id = inventory_item.match(/(\d+)/)[1]
  console.log('delete')
  console.log("/api/v1/inventory_items/#{id}")

deleteServiceLog = (service_log) ->
  $('#delete-service-log-confirm').modal('show')
  id = service_log.match(/(\d+)/)[1]
  console.log('edit')
  console.log("/api/v1/service_logs/#{id}")

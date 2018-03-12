'use strict';

$(document).ready(function(){
  new herokuConnection
});

class herokuConnection{
    constructor(){
      this.orgs = $('.organizations').data('organizations');
      this.token = $('.organizations').data('token');
      this.herokuKey = btoa(":" + this.token + "\n");
      this.dataJSON = [];
      this.getOrganizations();
      this.doSomething();
    }

    getOrganization(org){
      $.ajax({
        type: "GET",
        dataType: "json",
        url: "https://api.heroku.com/organizations/" + org['name'] + "/invoices",
        cache: true,
        beforeSend: function(request){
            request.setRequestHeader("Authorization", this.herokuKey);
            request.setRequestHeader('Accept', "application/vnd.heroku+json; version=3");
        }.bind(this),
      }).done(function(response){
        var trHTML = '';
        var headerHTML =  `<div class="column"><table class="organizations table is-bordered is-striped">
              <thead>
                <tr><th class='is-info' colspan='5'>${org.name}</th></tr>
                <tr>
                  <th><abbr title="Name">Name</abbr></th>
                  <th><abbr title="Add-ons">Add-ons</abbr></th>
                  <th><abbr title="Dyno-units">Dyno Units</abbr></th>
                  <th><abbr title="Database-total">Database Total</abbr></th>
                  <th><abbr title="Total-cost">Total $</abbr></th> 
                </tr>
              </thead>
                  <tbody>`

        var sortByDescDate = response.sort(function(a, b){
                            var dateA = new Date(a.period_end), dateB = new Date(b.period_end);
                             return dateA - dateB;
                         }).reverse();



        $.each(sortByDescDate, function (i, item){
            var date = new Date(item.period_start);
            var monthName = new Intl.DateTimeFormat("en-US", { month: "long" }).format;
            var longName = monthName(date);

            if (i == 0){
                trHTML += headerHTML;
                trHTML += "<tr class='latest'><td>" + longName  + '</td><td>' + item.addons_total + '</td><td>' + item.dyno_units + '</td><td>' + item.database_total + '</td><td>' + item.total + '</td></tr>';
            } else {
                trHTML += '<tr><td>' + longName  + '</td><td>' + item.addons_total + '</td><td>' + item.dyno_units + '</td><td>' + item.database_total + '</td><td>' + item.total + '</td></tr>';
            }

            if (i == (this.length - 1)){
                trHTML += '</tbody></table></div>'
                trHTML += "<div class='expand column is-half'>More <i class='fas fa-arrow-alt-circle-down'></i></div"
            }
        }.bind(sortByDescDate));

        if (org.name){
            $( 'section .' + org.name ).append(trHTML);
        }
      }.bind(org)).fail(function(response, textStatus, error){
              console.log(textStatus + ": " + error + ".  Message:" + response.responseJSON['message']);
      });
   }

  getOrganizations() {
    // this.orgs.slice(0,3).forEach(function(org) {
    this.orgs.forEach(function(org){
        this.getOrganization(org);
    }.bind(this));
  }

  tableHeader() {
    return `<table class="table">
            <thead>
              <tr>
                <th><abbr title="Name">Name</abbr></th>
                <th><abbr title="Add-ons">Add-ons</abbr></th>
                <th><abbr title="Dyno-units">Dyno Units</abbr></th>
                <th><abbr title="Database-total">Database Total</abbr></th>
                <th><abbr title="Total-cost">Total $</abbr></th> 
              </tr>
            </thead>
                <tbody>`
  }

  doSomething(){
    $('.is-half').on('click', '.expand', function(e){
    var rows = $(this).parent().find('tr:gt(2):not(.latest)');
    if (rows.is(':hidden')) {
      rows.show();
    } else {
      rows.hide();
    }
    e.stopPropagation();
    e.preventDefault();
   });
  }
}

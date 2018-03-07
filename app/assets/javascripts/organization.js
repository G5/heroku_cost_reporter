$(document).ready(function() {
    new herokuConnection
});

class herokuConnection {
    constructor(){
        this.orgs = $('.organizations').data('organizations');
        this.token = $('.organizations').data('token');
        this.herokuKey = btoa(":" + this.token + "\n");
        this.dataJSON = [];
        this.getOrganizations();
    }

    getOrganization(org) {
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "https://api.heroku.com/organizations/" + org['name'] + "/invoices",
            cache: true,
            beforeSend: function(request) {
                request.setRequestHeader("Authorization", this.herokuKey);
                request.setRequestHeader('Accept', "application/vnd.heroku+json; version=3");
            }.bind(this),
        }).done(function(response){
            var trHTML = '';
            var headerHTML =  `<table class="table">
                  <thead>
                    <tr class='is-info' colspan='5'>${org.name}</tr>
                    <tr>
                      <th><abbr title="Name">Name</abbr></th>
                      <th><abbr title="Add-ons">Add-ons</abbr></th>
                      <th><abbr title="Dyno-units">Dyno Units</abbr></th>
                      <th><abbr title="Database-total">Database Total</abbr></th>
                      <th><abbr title="Total-cost">Total $</abbr></th> 
                    </tr>
                  </thead>
                      <tbody>`

            $.each(response, function (i, item) {
                if (i == 0){
                    trHTML += headerHTML;
                }
                trHTML += '<tr><td> Month' + i + '</td><td>' + item.addons_total + '</td><td>' + item.dyno_units + '</td><td>' + item.database_total + '</td><td>' + item.total + '</td></tr>';
            });
            
            if (org.name) {
                $( 'section .' + org.name ).append(trHTML);
            }
        }.bind(org)).fail(function(response, textStatus, error) {
                console.log(textStatus + ": " + error + ".  Message:" + response.responseJSON['message']);
        });
   }

    getOrganizations() {
        this.orgs.slice(0,3).forEach(function(org) {
            this.getOrganization(org);
        }.bind(this));
    }

    // tableHeader() {
        // return `<table class="table">
                  // <thead>
                    // <tr>
                      // <th><abbr title="Name">Name</abbr></th>
                      // <th><abbr title="Add-ons">Add-ons</abbr></th>
                      // <th><abbr title="Dyno-units">Dyno Units</abbr></th>
                      // <th><abbr title="Database-total">Database Total</abbr></th>
                      // <th><abbr title="Total-cost">Total $</abbr></th> 
                    // </tr>
                  // </thead>
                      // <tbody>`

    // }
}

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require moment

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require fullcalendar

function clearCalendar() {
    $('#calendar').html('');
};

function displayCalendar(){
    $('#calendar').fullCalendar({
        events: '/seminars.json',
        titleFormat: 'YYYY年 M月',
        dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
        header: {
            left: '',
            center: 'title',
            right: 'today prev,next'
        },
        defaultTimedEventDuration: '03:00:00',
        buttonText: {
            prev: '前',
            next: '次',
            prevYear: '前年',
            nextYear: '翌年',
            today: '今日',
            month: '月',
            week: '週',
            day: '日'
        },
        editable: true,
        timeFormat: "HH:mm",
        eventColor: '#87cefa',
        eventTextColor: '#000000',
        eventRender: function(event, element) {
            element.css("font-size", "0.8em");
            element.css("padding", "5px");
        }
    });
}


$(document).on('turbolinks:load', function () {
    displayCalendar();
    $('#chat_message').on('keyup', (function() {
        console.log('Change!');
        if ( $('#chat_message').val() == '') {
            $('.chat-btn').prop('disabled', true);
        } else {
            $('.chat-btn').prop('disabled', false);
        }
    }));
});

$(document).on('turbolinks:before-cache', function(){
  clearCalendar();
  displayCalendar();
});

$(function() {
    $('.menu-trigger').on('click', function(event) {
      $(this).toggleClass('active');
      $('#sp-menu').fadeToggle();
      event.preventDefault();
    });
});

$(function() {
    $('#back a').on('click',function(event){
      $('body, html').animate({
        scrollTop:0
      }, 800);
      event.preventDefault();
    });
});

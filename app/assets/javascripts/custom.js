$(function() {

 // Below is the name of the textfield that will be autocomplete    
    $('#search').autocomplete({
 // This shows the min length of charcters that must be typed before the autocomplete looks for a match.
            minLength: 2,
 // This is the source of the auocomplete suggestions. In this case a list of names from the people controller, in JSON format.
            source: '/search_suggestions',
  // This updates the textfield when you move the updown the suggestions list, with your keyboard. In our case it will reflect the same value that you see in the suggestions which is the term.
            focus: function(event, ui) {
                $('#search').val(ui.item.term_type);
                return false;
            },
 // Once a value in the drop down list is selected, do the following:
            select: function(event, ui) {
 // place the term value into the textfield called 'search'...
                if(ui.item.course_id== null){
                  location.href = "/courses?utf8=✓&search="+encodeURI(ui.item.term);
                // $('#search').val(ui.item.term);
                }
                else{
                  location.href = "/courses/"+ui.item.course_id;  
                }
                return false;
            }
        })
 // The below code is straight from the jQuery example. It formats what data is displayed in the dropdown box, and can be customized.
        .data( "uiAutocomplete" )._renderItem = function( ul, item ) {
            return $( "<li></li>" )
                .data( "item.uiAutocomplete", item )
 // For now which just want to show the term in the list.
                .append( "<a>" + item.term + "</a>" )
                .appendTo( ul );
        };
    });
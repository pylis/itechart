function openbox(id) {
    var div = document.getElementById(id);

    if(div.style.display == 'block') {
        div.style.display = 'none';
    }
    else {
        div.style.display = 'block';
    }
}

function addPhone(id){
    var form = document.getElementById(id);
    form.command.value ='phone';
    form.mode.value= 'add';
    form.submit();
}

function saveContact(){
    var form= document.getElementById("form");
    form.command.value = 'save';
    form.submit();
}
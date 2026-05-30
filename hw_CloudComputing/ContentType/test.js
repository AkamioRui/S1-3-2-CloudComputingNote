// via queryString
import fs from 'fs'

// console.log(fs.readFileSync('test.http').toString());


queryString()
function queryString(){
    fetch('http://localhost:8000?'+new URLSearchParams({'qs_a':100,'qs_b':'sldaf'}))
    .then(
        res => res.text(),
        reason => console.log(reason)
    )
    .then(
        res => console.log('-----queryString-----',res),
        reason => console.log(reason)
    )
} 


application_json()
function application_json(){
    fetch('http://localhost:8000',{
        method:'POST',
        headers:{
            'Content-Type':'application/json'
        },
        body:JSON.stringify({'json_a':12,'json_b':'hello'})
    })
    .then(
        res => res.text(),
        reason => console.log(reason)
    )
    .then(
        res => console.log('-----application_json-----',res),
        reason => console.log(reason)
    )
} 


application_x_www_form_urlencoded()
function application_x_www_form_urlencoded(){
    fetch('http://localhost:8000',{
        method:'POST',
        headers:{
            'Content-Type':'application/x-www-form-urlencoded'
        },
        body:new URLSearchParams({'xwww_c':1,'xwww_d':"from x-www"})
    })
    .then(
        res => res.text(),
        reason => console.log(reason)
    )
    .then(
        res => console.log('-----application_x_www_form_urlencoded-----',res),
        reason => console.log(reason)
    )
} 


// multipart/form-data
multipart_form_data()
function multipart_form_data(){
    let mydata = new FormData();
    mydata.append('myfile',fs.createReadStream('test.http'))
    
    fetch('http://localhost:8000',{
        method:'POST',
        body:mydata
    })
    .then(
        res => res.text(),
        reason => console.log(reason)
    )
    .then(
        res => console.log('-----multipart/form-data-----',res),
        reason => console.log(reason)
    )
} 
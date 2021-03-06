<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create contact</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/contact.js"></script>
    <link rel="stylesheet" href="/style/contact.css">
</head>
<body  onload="selectAvatar()">

<!--Navigation bar -->

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/controller?command=show">
                <span class="glyphicon glyphicon-user"></span> My contacts</a>
        </div>
        <div>
            <ul class="nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/controller?command=search">
                    <span class="glyphicon glyphicon-search"></span> Search contacts</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <a href="javascript:{}" onclick="document.getElementById('avatar').click()">
        <img id="image" src="${pageContext.request.contextPath}/controller?command=avatar&idContact=${contact.id}">
    </a>
    <input id="avatar" type="file" name="avatar" form="form" class="file" accept="image/*" style="display: none">

    <h1>My contact</h1>

    <!--Main form with input fields -->

    <form id="form" action="${pageContext.request.contextPath}/controller" class="form-horizontal" method="post"
          accept-charset="utf-8" enctype="multipart/form-data" role="form">
        <!--For paging-->
        <input type="hidden" name="mode" value="${mode}">

        <input type="hidden" name="command"  value="save">

        <input type="hidden" name="idContact" value="${contact.id}">

        <div class="form-group">
            <label class="control-label col-sm-2" for="name">Name:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.name}" pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*" class="form-control"
                       id="name" name="name" placeholder="Enter name"  maxlength="20" required>
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="surname">Surname:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.surname}" pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*" class="form-control"
                       id="surname" name="surname" placeholder="Enter surname" maxlength="40" required>
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="middname">Middle name:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.midName}" pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*" class="form-control"
                       id="middname" name="middname" maxlength="30" placeholder="Enter middle name">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="birthday">Birthday:</label>
            <div class="col-sm-10">
                <input type="date" value="${contact.birthday}" max="2010-12-31"
                      min="1900-12-31"  class="form-control" id="birthday" name="birthday"
                       placeholder="Enter birthday">
            </div>
        </div>

        <div class="form-group">
            <label for="gender" class="control-label col-sm-2">Gender:</label>
            <div class="col-sm-5">
                <select name="gender" class="form-control" id="gender">
                    <option ${contact.gender == 'Male' ? 'selected' : ''}>Male</option>
                    <option ${contact.gender == 'Female' ? 'selected' : ''}>Female</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="national">Nationality:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.nationality}" class="form-control"
                       maxlength="20"   pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*" id="national" name="national"
                       placeholder="Enter nationality">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="maritStatus">Marital status:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.maritStatus}" pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*"
                       maxlength="20"   class="form-control" id="maritStatus" name="maritStatus"
                       placeholder="Enter marital status">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="site">Website:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.site}" class="form-control"
                       pattern="^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$" id="site"
                       maxlength="30"   name="site" placeholder="Enter website">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="email">Email:</label>
            <div class="col-sm-10">
                <input type="email" value="${contact.email}" pattern="^[-\w.]+@([A-z0-9][-A-z0-9]+\.)+[A-z]{2,4}$"
                       maxlength="60"  class="form-control" id="email" name="email" placeholder="Enter email">
            </div>
        </div>


        <div class="form-group">
            <label class="control-label col-sm-2" for="company">Company:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.company}" pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*" class="form-control"
                       maxlength="40"  id="company" name="company" placeholder="Enter company">
            </div>
        </div>

        <input type="hidden" name="idAddress" value="${contact.address.idAddress}">

        <div class="form-group">
            <label class="control-label col-sm-2" for="country">Address:</label>
            <div class="col-sm-10">
                <input type="text" value="${contact.address.country}"
                       pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*" class="form-control" id="country" name="country"
                       maxlength="30"   placeholder="Enter country">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2"></label>
            <div class="col-sm-10">
                <input type="text" value="${contact.address.city}" pattern="([a-z]|[A-Z]|[а-я]|[А-Я])*"
                       maxlength="20"  class="form-control"  name="city" placeholder="Enter city">
            </div>
        </div>


        <div class="form-group">
            <label class="control-label col-sm-2"></label>
            <div class="col-sm-10">
                <input type="text" value="${contact.address.address}" class="form-control"  name="address"
                       maxlength="80"  placeholder="Enter address">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2"></label>
            <div class="col-sm-10">
                <input type="text" maxlength="10" value="${contact.address.index}" pattern="\d*" class="form-control"
                       name="index" placeholder="Enter index">
            </div>
        </div>
    </form>

    <!--Pop-up for phones -->

    <div id="phonePopUp" style="display:none">
        <div class='tt'>
            <div class="container">
                <form id="telephone" class="form-horizontal" accept-charset="utf-8" role="form">
                    <div style="margin: auto auto 2% auto">
                        <div class="close" onclick="phoneService.cancelPhone()">x</div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-2" for="countryCode">Country code:</label>
                        <div class="col-sm-2">
                            <input  type="number" min="0" class="form-control" max="1000" id="countryCode"
                                    name="countryCode" placeholder="Country code">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-2" for="operatorCode">Operator code:</label>
                        <div class="col-sm-2">
                            <input type="number" min="0" class="form-control" id="operatorCode" name="operatorCode"
                                   placeholder="Operator code" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-2" for="phone">Telephone:</label>
                        <div class="col-sm-5">
                            <input type="number" min="0" class="form-control" id="phone" name="phone" placeholder="Telephone" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="kind" class="control-label col-sm-2">Kind:</label>
                        <div class="col-sm-5">
                            <select name="kind" class="form-control" id="kind">
                                <option>Home</option>
                                <option>Mobile</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-2" for="comment">Comment:</label>
                        <div class="col-sm-5">
                            <textarea  class="form-control" rows="5" name="comment" id="comment"
                                       maxlength="60"  placeholder="Type your comment..."></textarea>
                        </div>
                    </div>
                </form>

                <button  onclick="phoneService.savePhone()" class="btn btn-default">Save</button>
                <button onclick="phoneService.cancelPhone()" class="btn btn-default">Cancel</button>
            </div>
        </div>
    </div>

    <!--Pop-up for attachments -->

    <div id="attachPopUp" style="display:none">
        <div id="attachTT">
            <div class="container form-horizontal">
                <div style="margin: auto auto 2% auto">
                    <div class="close" onclick="attachService.cancelAttach()">x</div>
                </div>

                <div id="b_file_name">
                    <div class="form-group" >
                        <label class="control-label col-sm-2" for="file_name">File:</label>
                        <div class="col-sm-5">
                            <input  type="text" form="form" name="file_name" class="form-control" id="file_name" readonly>
                        </div>
                    </div>
                </div>

                <div id="b_attach">
                    <div class="form-group" >
                        <label class="control-label col-sm-2" for="attach">Choose file:</label>
                        <div class="col-sm-5">
                            <input  type="file"  form="form" class="form-control" id="attach" name="attach" >
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2" for="attachComment">Comment:</label>
                    <div class="col-sm-5">
                        <textarea  class="form-control" form="form" rows="5" name="attach_comment"
                                   id="attachComment" maxlength="60" placeholder="Type your comment..."></textarea>
                    </div>
                </div>

                <input form="form" type="hidden" name="attachMode">
                <button  onclick="attachService.saveAttach()" class="btn btn-default">Save</button>
                <button onclick="attachService.cancelAttach()" class="btn btn-default">Cancel</button>
            </div>
        </div>
    </div>

    <br>

    <!--Table of phones and buttons -->

    <div class="panel panel-default">
    <div style="float: right;">
        <button onclick="phoneService.addPhone()" class="btn btn-default">Add</button>
        <button onclick="phoneService.deletePhone()" class="btn btn-default">Delete</button>
        <button onclick="phoneService.editPhone()" class="btn btn-default">Edit</button>
    </div>

        <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-phone-alt"></span> Phones</h3>
        </div>
        <table class="table">
            <thead>
            <tr>
                <th></th>
                <th>Full telephone</th>
                <th>Description</th>
                <th>Commment</th>
            </tr>
            </thead>
            <tbody id="phoneTable">
            <c:forEach items="${phones}" var="phone" varStatus="num">
                <tr>
                    <td>
                        <input type='checkbox'  name='phones'/>
                    </td>
                    <td><input type='text' form='form' value="${ phone.getFullPhone()}" readonly/></td>
                    <td><input type='text' form='form' name="kind${ num.count - 1 }" value="${ phone.kind}" readonly/></td>
                    <td><input type='text' form='form' name="comment${ num.count - 1 }" value="${ phone.comment}" readonly/></td>
                    <td><input type='hidden' form='form' name="countryCode${ num.count - 1}" value="${ phone.countryCode}" readonly/></td>
                    <td><input type='hidden' form='form' name="operatorCode${ num.count - 1}" value="${ phone.operatorCode}" readonly/></td>
                    <td><input type='hidden' form='form' name="phone${ num.count - 1}" value="${ phone.number}" readonly/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <hr>
    <!--Table of attachments and buttons-->
    <div class="panel panel-default">
    <div style="float: right">
        <button onclick="attachService.addAttach()" class="btn btn-default">Add</button>
        <button onclick="attachService.deleteAttach()" class="btn btn-default">Delete</button>
        <button onclick="attachService.editAttach()" class="btn btn-default">Edit</button>
    </div>
        <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-paperclip"></span> Attachments</h3>
        </div>
        <table class="table" >
            <thead>
            <tr>
                <th></th>
                <th>Name</th>
                <th>Date of load</th>
                <th>Commment</th>
            </tr>
            </thead>
            <tbody id="attachTable">
            <c:forEach items="${attaches}" var="attach" varStatus="num">
                <c:set var="link"  value= 'href= "/controller?command=attach&idContact=${contact.id}&name=${attach.name}"
                class="active"'/>
                <tr>
                    <td>
                        <input type='checkbox' form="form" name='attaches' value="${attach.name}"/>
                    </td>
                    <td>

                        <a  ${attach.idAttach == null ? 'href="javascript: void(0)" class="noactive"' : link} >
                             ${attach.name}
                        </a>
                    </td>
                    <td><input type='date'  value="${ attach.date}" readonly/></td>
                    <td><input type='text'  value="${ attach.comment}" readonly/></td>
                    <td><input type="hidden" value="${attach.name}"></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <button form="form" type="submit" class="btn btn-default pull-left btn-lg">Save</button>
</div>

</body>
</html>

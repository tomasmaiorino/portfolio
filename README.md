# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
* Creating client:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\": \"monsters\", \"token\":\"tkclient\", \"active\":true, \"host\":\"localhost\", \"security_permissions\":1}" http://localhost:3000/api/v1/client
Sample response:
{"id":3}

* Update client
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":3, \"name\": \"monsters two\", \"token\":\"tkclient\", \"active\":true, \"security_permissions\":1}" http://localhost:3000/api/v1/client
Sample response:
{"id":3}

* Find client:
curl http://localhost:3000/api/v1/client/1
Sample response:
{"id":1,"name":"tomas","active":true,"token":"tkn","host":null,"security_permissions":1,"created_at":"2016-11-25T19:46:39.047Z","updated_at":"2016-11-25T19:46:39.047Z"}

* Creating tech tags:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"monsters\", \"active\":true,  \"ct\":\"tkclient\"}" http://localhost:3000/api/v1/tech_tag
Sample response:
{"id":3}

* Update Tech Tag
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":1, \"name\":\"JAVA\", \"active\":true, \"ct\":\"tkclient\"}" http://localhost:3000/api/v1/tech_tag

* Find Tech Tag
curl http://localhost:3000/api/v1/tech_tag/1
Sample response:
{"id":1,"name":"monsters","active":true,"created_at":"2016-11-25T20:41:21.510Z","updated_at":"2016-11-25T20:41:21.510Z"}

* Creating Skill tags:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Java JavaEE\",\"level\":94,\"ct\":\"tkclient\"}" http://localhost:3000/api/v1/skill
Sample response:
{"id":1}

* Update Skill tags:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"id\":1,\"name\":\"Java Developer JavaEE\",\"level\":54,\"ct\":\"tkclient\"}" http://localhost:3000/api/v1/skill
Sample response:
{"id":1}

* Find Skill
curl http://localhost:3000/api/v1/skill/1
Sample response:
{"id":1,"name":"Java JavaEE","level":94,"created_at":"2016-11-25T21:12:51.135Z","updated_at":"2016-11-25T21:12:51.135Z"}


* Creating Projects:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Recover Password\",\"img\":\"assets/images/projects/netshoes.png\",\"link_img\":\"http://www.netshoes.com.br\",\"summary\":\"Change the recover password workflow\",\"description\":\"description description description description description description description description description\",\"improvements\":\"Reduce the support calls in 20%\",\"time_spent\":\"2 weeks\",\"active\":true,\"future_project\":false,\"project_date\":\"2016-11-25T19:46:39.047Z\",\"ct\":\"tkclient\",\"tech_tags\":[1,2]}" http://localhost:3000/api/v1/project

* Updating Projects:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":1,\"name\":\"Recover Password\",\"img\":\"assets/images/projects/netshoes.png\",\"link_img\":\"http://www.netshoes.com.br\",\"summary\":\"Change the recover password workflow\",\"description\":\"description description description description description description description description description\",\"improvements\":\"Reduce the support calls in 20%\",\"time_spent\":\"3 weeks\",\"active\":true,\"future_project\":false,\"project_date\":\"2016-11-25T19:46:39.047Z\",\"ct\":\"tkclient\",\"tech_tags\":[1],\"companies\":[1]}" http://localhost:3000/api/v1/project


* Find Project
curl http://localhost:3000/api/v1/project/1
Sample response:
{"id":2,"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"2 weeks","language":"en","active":true,"future_project":false,"project_date":"2016-11-25T19:46:39.047Z","created_at":"2016-11-25T21:57:31.109Z","updated_at":"2016-11-25T21:57:31.109Z","tech_tags":[{"name":"JAVA"},{"name":"SQL"}]}

* Creating Company:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Lab\",\"token\":\"labtk\",\"email\":\"lab@lab.com\",\"ct\":\"tkclient\",\"active\":true,\"main_color\":\"#FF0000\",\"client_id\":2}" http://localhost:3000/api/v1/company

* Updating Company
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":1,\"name\":\"Lab\",\"token\":\"labtk\",\"email\":\"lab@lab.com\",\"ct\":\"tkclient\",\"active\":true,\"main_color\":\"#FF0000\",\"client_id\":2,\"skills\":[1]}" http://localhost:3000/api/v1/company

* Find company by token (For now the company is being returned only if it has at least a project associated to it)
$ curl -ihttp://localhost:3000/api/v1/company/token/labtk
Sample response:
{"id":1,"client_id":2,"active":true,"token":"labtk","email":"lab@lab.com","manager_name":null,"name":"Lab","main_color":"#FF0000","cover_letter":null,"created_at":"2016-11-25T23:12:58.640Z","updated_at":"2016-11-25T23:12:58.640Z","skills":[{"name":"Java Developer JavaEE","level":54}],"projects":[{"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"3 weeks","future_project":false,"project_date":"2016-11-25T19:46:39.047Z","tech_tags":[{"name":"JAVA"}]}]}

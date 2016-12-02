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
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Tomas\",\"token\":\"df2a0983392\",\"active\":true,\"host\":\"localhost\",\"security_permissions\":1}" http://localhost:3000/api/v1/client
Sample response:
{"id":1}

* Update client
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":3, \"name\": \"monsters two\", \"token\":\"df2a0983392\", \"active\":true, \"security_permissions\":1}" http://localhost:3000/api/v1/client
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
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Recover Password\",\"img\":\"assets/images/projects/netshoes.png\",\"link_img\":\"http://www.netshoes.com.br\",\"summary\":\"Change the recover password workflow\",\"description\":\"description description description description description description description description description\",\"improvements\":\"Reduce the support calls in 20%\",\"time_spent\":\"2 weeks\",\"active\":true,\"future_project\":false,\"project_date\":\"2016-11-25T19:46:39.047Z\",\"ct\":\"df2a0983392\",\"tech_tags\":[1,2,4,5],\"companies\":[1]}" http://localhost:3000/api/v1/project

* Updating Projects:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":1,\"name\":\"Recover Password\",\"img\":\"assets/images/projects/netshoes.png\",\"link_img\":\"http://www.netshoes.com.br\",\"summary\":\"Change the recover password workflow\",\"description\":\"description description description description description description description description description\",\"improvements\":\"Reduce the support calls in 20%\",\"time_spent\":\"2 weeks\",\"active\":true,\"future_project\":false,\"project_date\":\"2016-11-25T19:46:39.047Z\",\"ct\":\"df2a0983392\",\"tech_tags\":[1,2,4,5],\"companies\":[1,2]}" http://localhost:3000/api/v1/project



* Find Project
curl http://localhost:3000/api/v1/project/1
Sample response:
{"id":2,"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"2 weeks","language":"en","active":true,"future_project":false,"project_date":"2016-11-25T19:46:39.047Z","created_at":"2016-11-25T21:57:31.109Z","updated_at":"2016-11-25T21:57:31.109Z","tech_tags":[{"name":"JAVA"},{"name":"SQL"}]}

* Creating Company:
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Lab\",\"token\":\"e5fcdf02e2600a1e4\",\"email\":\"lab@lab.com\",\"ct\":\"df2a0983392\",\"active\":true,\"main_color\":\"#FF0000\",\"client_id\":1,\"skills\":[1,3]}" http://localhost:3000/api/v1/company


curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Monsters\",\"token\":\"e5fcdf02e26\",\"email\":\"monsters@monsters.com\",\"ct\":\"df2a0983392\",\"active\":true,\"main_color\":\"#FF0000\",\"client_id\":1}" http://localhost:3000/api/v1/company


* Updating Company
curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":2,\"manager_name\":\"Jeff\",\"name\":\"Monsters\",\"token\":\"e5fcdf02e2600a1e4\",\"email\":\"monsters@monsters.com\",\"ct\":\"df2a0983392\",\"active\":true,\"main_color\":\"#FF0000\",\"client_id\":1,\"skills\":[1,3]}" http://localhost:3000/api/v1/company


* Find company by token (For now the company is being returned only if it has at least a project associated to it)
$ curl -ihttp://localhost:3000/api/v1/company/token/e5fcdf02e2600a1e4
Sample response:
{"id":1,"client_id":2,"active":true,"token":"labtk","email":"lab@lab.com","manager_name":null,"name":"Lab","main_color":"#FF0000","cover_letter":null,"created_at":"2016-11-25T23:12:58.640Z","updated_at":"2016-11-25T23:12:58.640Z","skills":[{"name":"Java Developer JavaEE","level":54}],"projects":[{"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"3 weeks","future_project":false,"project_date":"2016-11-25T19:46:39.047Z","tech_tags":[{"name":"JAVA"}]}]}


* Find Company's skills by token
$ curl -i hst:3000/api/v1/company/skill/0e8c7467e46
Sample response:
{"skills":[{"name":"Java \u0026amp; j2e","level":96},{"name":"Javascript \u0026amp; jquery","level":70},{"name":"Databases","level":60},{"name":"Ruby on rails","level":40}]}

* Find Company's projects tech by token
$ curl -i hst:3000/api/v1/company/tech/0e8c7467e46
Sample response:
{"tech_tags":["BCC","ATG-11","GIT","REST"]}


* Find Company' by company's client id
 $ curl -i http://localhost:3000/api/v1/company/1
 Sample response:
 [{"id":1,"client_id":1,"active":true,"token":"0e8c7467e46","email":"lab@lab.com","manager_name":null,"name":"Lab","main_color":"#FF0000","cover_letter":null,"skills":[{"name":"Java \u0026amp; j2e","level":96},{"name":"Javascript \u0026amp; jquery","level":70},{"name":"Databases","level":60},{"name":"Ruby on rails","level":40}],"projects":[{"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"2 weeks","future_project":false,"project_date":"2016-11-25T19:46:39.047Z","tech_tags":[{"name":"BCC"},{"name":"ATG-11"},{"name":"GIT"},{"name":"REST"}]}]},{"id":2,"client_id":1,"active":true,"token":"e5fcdf02e26","email":"monsters@monsters.com","manager_name":"Jeff","name":"Monsters","main_color":"#FF0000","cover_letter":null,"skills":[],"projects":[{"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"2 weeks","future_project":false,"project_date":"2016-11-25T19:46:39.047Z","tech_tags":[{"name":"BCC"},{"name":"ATG-11"},{"name":"GIT"},{"name":"REST"}]}]}]t

# README
It is a rest service which is used to create portifolios which can be used for job positions.
Using this service, the user can create specifics projects, skills, cover letter for each company who is applying for a job to.

* Ruby version
  2.0

* System dependencies
  - Ruby 2.0
  - Rails 5.0.0
  - postgresql

* Database initialization
  $ rake db:migrate
  $ rake db:seed

* How to run the test suite
  $ rake test

* Services (job queues, cache servers, search engines, etc.)
- Creating client:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Tomas\",\"token\":\"df2a0983392\",\"active\":true,\"host\":\"localhost\",\"security_permissions\":1}" http://localhost:3000/api/v1/client
response: {"id":1}

- Update client
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":3, \"name\": \"monsters two\", \"token\":\"df2a0983392\", \"active\":true, \"security_permissions\":1}" http://localhost:3000/api/v1/client
response: {"id":3}

- Find client:
$ curl http://localhost:3000/api/v1/client/1
response: {"id":1,"name":"tomas","active":true,"token":"tkn","host":null,"security_permissions":1,"created_at":"2016-11-25T19:46:39.047Z","updated_at":"2016-11-25T19:46:39.047Z"}

- Creating tech tags:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"monsters\", \"active\":true,  \"ct\":\"tkclient\"}" http://localhost:3000/api/v1/tech_tag
response: {"id":3}

- Update Tech Tag
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":1, \"name\":\"JAVA\", \"active\":true, \"ct\":\"tkclient\"}" http://localhost:3000/api/v1/tech_tag

- Find Tech Tag
$ curl http://localhost:3000/api/v1/tech_tag/1
response: {"id":1,"name":"monsters","active":true,"created_at":"2016-11-25T20:41:21.510Z","updated_at":"2016-11-25T20:41:21.510Z"}

- Creating Skill tags:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Java JavaEE\",\"level\":94,\"ct\":\"df2a0983392\"}" http://localhost:3000/api/v1/skill
response: {"id":1}

- Update Skill tags:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"id\":1,\"name\":\"Java Developer JavaEE\",\"level\":54,\"ct\":\"df2a0983392\"}" http://localhost:3000/api/v1/skill
response: {"id":1}

- Find Skill
$ curl http://localhost:3000/api/v1/skill/1
response: {"id":1,"name":"Java JavaEE","level":94,"created_at":"2016-11-25T21:12:51.135Z","updated_at":"2016-11-25T21:12:51.135Z"}

- Creating Projects:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Recover Password\",\"img\":\"assets/images/projects/netshoes.png\",\"link_img\":\"http://www.netshoes.com.br\",\"summary\":\"Change the recover password workflow\",\"description\":\"description description description description description description description description description\",\"improvements\":\"Reduce the support calls in 20%\",\"time_spent\":\"2 weeks\",\"active\":true,\"future_project\":false,\"project_date\":\"2016-11-25T19:46:39.047Z\",\"ct\":\"df2a0983392\",\"tech_tags\":[1,2,4,5],\"companies\":[1]}" http://localhost:3000/api/v1/project
response: {"id":1}

- Updating Projects:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":1,\"name\":\"Recover Password\",\"img\":\"assets/images/projects/netshoes.png\",\"link_img\":\"http://www.netshoes.com.br\",\"summary\":\"Change the recover password workflow\",\"description\":\"description description description description description description description description description\",\"improvements\":\"Reduce the support calls in 20%\",\"time_spent\":\"2 weeks\",\"active\":true,\"future_project\":false,\"project_date\":\"2016-11-25T19:46:39.047Z\",\"ct\":\"df2a0983392\",\"tech_tags\":[1,2,4,5],\"companies\":[1,2]}" http://localhost:3000/api/v1/project

- Find Project
$ curl http://localhost:3000/api/v1/project/1
response: {"id":2,"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"2 weeks","language":"en","active":true,"future_project":false,"project_date":"2016-11-25T19:46:39.047Z","created_at":"2016-11-25T21:57:31.109Z","updated_at":"2016-11-25T21:57:31.109Z","tech_tags":[{"name":"JAVA"},{"name":"SQL"}]}

- Creating Company:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"name\":\"Lab\",\"token\":\"e5fcdf02e2600a1e4\",\"email\":\"lab@lab.com\",\"ct\":\"df2a0983392\",\"active\":true,\"main_color\":\"#FF0000\",\"client_id\":1,\"skills\":[1,3]}" http://localhost:3000/api/v1/company

- Updating Company
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X PUT -d "{\"id\":1,\"manager_name\":\"Jeff\",\"name\":\"Monsters\",\"token\":\"e5fcdf02e2600a1e4\",\"email\":\"monsters@monsters.com\",\"ct\":\"df2a0983392\",\"active\":true,\"main_color\":\"#FF0000\",\"client_id\":1,\"skills\":[1,3],\"cover_letter\":\"\"}" http://localhost:3000/api/v1/company


- Find company by token (For now the company is being returned only if it has at least a project associated to it)
$ curl -i http://localhost:3000/api/v1/company/token/e5fcdf02e2600a1e4
response: {"id":1,"client_id":2,"active":true,"token":"labtk","email":"lab@lab.com","manager_name":null,"name":"Lab","main_color":"#FF0000","cover_letter":null,"created_at":"2016-11-25T23:12:58.640Z","updated_at":"2016-11-25T23:12:58.640Z","skills":[{"name":"Java Developer JavaEE","level":54}],"projects":[{"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"3 weeks","future_project":false,"project_date":"2016-11-25T19:46:39.047Z","tech_tags":[{"name":"JAVA"}]}]}

- Find Company's skills by token
$ curl -i hst:3000/api/v1/company/skill/0e8c7467e46
response: {"skills":[{"name":"Java \u0026amp; j2e","level":96},{"name":"Javascript \u0026amp; jquery","level":70},{"name":"Databases","level":60},{"name":"Ruby on rails","level":40}]}

- Find Company's projects tech by token
$ curl -i hst:3000/api/v1/company/tech/0e8c7467e46
response: {"tech_tags":["BCC","ATG-11","GIT","REST"]}

- Find Company' by company's client id
 $ curl -i http://localhost:3000/api/v1/company/1
response: [{"id":1,"client_id":1,"active":true,"token":"0e8c7467e46","email":"lab@lab.com","manager_name":null,"name":"Lab","main_color":"#FF0000","cover_letter":null,"skills":[{"name":"Java \u0026amp; j2e","level":96},{"name":"Javascript \u0026amp; jquery","level":70},{"name":"Databases","level":60},{"name":"Ruby on rails","level":40}],"projects":[{"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"2 weeks","future_project":false,"project_date":"2016-11-25T19:46:39.047Z","tech_tags":[{"name":"BCC"},{"name":"ATG-11"},{"name":"GIT"},{"name":"REST"}]}]},{"id":2,"client_id":1,"active":true,"token":"e5fcdf02e26","email":"monsters@monsters.com","manager_name":"Jeff","name":"Monsters","main_color":"#FF0000","cover_letter":null,"skills":[],"projects":[{"name":"Recover Password","img":"assets/images/projects/netshoes.png","link_img":"http://www.netshoes.com.br","summary":"Change the recover password workflow","description":"description description description description description description description description description","improvements":"Reduce the support calls in 20%","time_spent":"2 weeks","future_project":false,"project_date":"2016-11-25T19:46:39.047Z","tech_tags":[{"name":"BCC"},{"name":"ATG-11"},{"name":"GIT"},{"name":"REST"}]}]}]

- Creating rating without company:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"points\":5}" http://localhost:3000/api/v1/rating
response: {"id":1}

- Creating rating with company:
$ curl -i -H "Content-Type:application/json" -H "Accept:application/json" -X POST -d "{\"points\":5,\"cp\":\"e5fcdf02e2600a1e4\"}" http://localhost:3000/api/v1/rating
response: {"id":1}

- Recovering rating by company:
$ curl -i  http://localhost:3000/api/v1/rating/e5fcdf02e2600a1e4
response: {"id":4,"company_id":2,"points":5,"comments":null}

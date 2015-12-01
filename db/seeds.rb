# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(fname:"Test",lname:"User",username:"tuser",
		address:"1234 Street Rd, Philadlephia, 19001",
		phone:"2159876543",email:"tuser@gmail.com",password:"12345678",
		likes:"Long walks on the beach, rainy days, kittens",
		dislikes:"mean people, snakes, belching",
		add_info:"")
User.create(fname:"Ron",lname:"Jaworski",username:"ronjaw",
		address:"1600 Pennsylvania Avenue, Washington DC, 05005",
		phone:"6105551212",email:"ronjaw@hotmail.com",password:"12345678",
		likes:"Football, Schmidt's Beer, Moustaches",
		dislikes:"Cleats, Winter, Astroturf",
		add_info:"")
User.create(fname:"Randall",lname:"Cunningham",username:"rancun",
		address:"0 North Pole, Arctica, 000000",
		phone:"7171112222",email:"rcunn@hotmail.com",password:"12345678",
		likes:"Minnesota, Purple, Moustaches",
		dislikes:"Philadelphia, Pretzels, Chessesteaks",
		add_info:"")
User.create(fname:"Michael",lname:"Vick",username:"micvic",
		address:"255 Main St, Lewsiburg, Pa. 17837",
		phone:"3022223333",email:"mvick@live.com",password:"12345678",
		likes:"Dogs, Exercise, Green",
		dislikes:"PETA, The Media, The Internet",
		add_info:"")
User.create(fname:"Donovan",lname:"Mcnabb",username:"donmcn",
		address:"1212 Main St., Townsville, Pa. 19382",
		phone:"8063334444",email:"dmcnabb@geocities.com",password:"12345678",
		likes:"Passing, Running, Scoring",
		dislikes:"Batteries, Octopus, Marshmallows",
		add_info:"")
User.create(fname:"Peewee",lname:"Herman",username:"pwherm",
		address:"4321 Road Dr, Philadlephia, 19003",
		phone:"1234567890",email:"pwherman@gmail.com",password:"12345678",
		likes:"suits, red bicycles, talking furniture",
		dislikes:"The Alamo, hitchhiking, circus midgets",
		add_info:"")
User.create(fname:"Barack",lname:"Obama",username:"baroba",
		address:"1600 Pennsylvania Avenue, Washington DC, 05005",
		phone:"3011234567",email:"potus@gwhitehouse.gov",password:"12345678",
		likes:"Michelle, Being the boss, Long walks on the beach",
		dislikes:"The opposition, jellybeans, broccoli",
		add_info:"")

Event.create(date:Time.now,name:"Christmas 2015",deadline:Time.now + 15.days,
	location:"Amsterdam",max_price:25.00,min_price:15.00)
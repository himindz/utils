require 'ruby-jmeter'
test do
  header [
    { name: 'Content-Type', value: 'application/json' }
  ]
  threads count: 1, loops: 100, scheduler: false do
	  get name: 'Get /user/{id}', url: 'http://localhost:5000/user/43dd256d-6b15-40f9-af17-43c285583001'
  end
  
end.run( jtl: 'user_id.jtl')
require 'ruby-jmeter'
test do
  header [
    { name: 'Content-Type', value: 'application/json' }
  ]
  threads count: 1, loops: 100, scheduler: false do
	 get name: 'Get /user/me', url: 'http://localhost:5000/user/me'
  end
  
end.run( jtl: 'user_me.jtl')
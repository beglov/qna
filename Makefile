start:
	overmind start

stop:
	overmind stop

tests:
	SELENIUM_URL=http://localhost:4444/wd/hub bundle exec rspec

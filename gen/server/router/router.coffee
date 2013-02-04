#back end
sign      = require '../controllers/sign'
dashboard = require '../controllers/dashboard'
content   = require '../controllers/content'
operator  = require '../controllers/operator'
admin     = require '../controllers/admin'
category  = require '../controllers/category'
#front end
front     = require '../controllers/front'

exports = module.exports = ( app ) ->


	###################
	# 验证合法性
	###################
	
	authentication = ( req, res, next ) ->
		if req.cookies.member 
			next()
		else 
			#如果session存在，就进入dashboard，否则的话就重定向到登陆页面
			if req.session.member then next() else res.redirect '/asgard-signin'

	###################
	# setup
	###################

	#进入dashboard页面
	app.get '/setup', admin.setup

	#进入dashboard页面
	app.post '/setup', admin.add

	###################
	# front
	###################
	
	########################################################
	#临时，为了方便Brackets的使用
	#app.get '/client/views/front/index.html', ( req, res ) ->
	#	res.redirect '/'
	#app.get '/client/views/front/detail.html', ( req, res ) ->
	#	res.redirect '/t/:url'
	########################################################

	#front
	app.get '/', ( req, res ) ->

		#打印
		console.log '-- / -- '

		#进入首页
		front.articles req, res

		######################################################
		#暂时直接重定向到asgard-signin页面
		#res.redirect '/asgard-signin'
		######################################################
	
	#首页的分页
	app.get '/index/:page', front.articles
	
	#分类
	app.get '/category/:catename', front.category
	#分类（分页）
	app.get '/category/:catename/:page', front.category
	
	#用户
	app.get '/member/:operator', front.operator
	#用户（分页）
	app.get '/member/:operator/:page', front.operator

	###################
	# detail
	###################
	
	#文章详细页
	app.get '/t/:url', front.detail

	###################
	# sign
	###################

	#asgard-signin
	app.get '/asgard-signin', ( req, res ) ->

		#打印
		console.log '-- asgard-signin(GET) -- '

		#判断是否存在cookies与session
		#判断的逻辑是：
		# 1、cookies是要是登陆成功，都会存在
		# 2、session只有在选择保存登陆时，才会存在
		if req.cookies.member
			res.redirect '/dashboard'
		else
			if req.session.member then res.redirect '/dashboard' else sign.init req, res

	#登陆验证
	app.post '/asgard-signin', sign.signin

	#安全退出
	app.get '/signout', sign.signout

	###################
	# dashboard
	###################

	#进入dashboard页面
	app.get '/dashboard', authentication, dashboard.init
	
	#dashboard load more content
	app.get '/dashboard/content/page/:page', authentication, dashboard.page

	###################
	# operaotr
	###################

	#dashboard operator check username
	app.get '/dashboard/operator/checkunique/:username', authentication, operator.checkunique
	
	#dashboard operator add
	app.post '/dashboard/operator/add', authentication, operator.add
	
	#dashboard operator edit
	app.get '/dashboard/operator/edit/:username', authentication, operator.edit
	
	#dashboard operator save
	app.post '/dashboard/operator/save/:username', authentication, operator.save
	
	#dashboard operator delete
	app.get '/dashboard/operator/delete/:username', authentication, operator.delete
	
	#dashboard operator save( userinfo )
	app.post '/dashboard/operator/profile/:username', authentication, operator.profile
	
	#dashboard operator update( userinfo )
	app.get '/operator-profile', authentication, operator.updateprofile

	###################
	# category
	###################

	#dashboard category check username
	app.get '/dashboard/category/checkunique/:catename', authentication, category.checkunique
	
	#dashboard category add
	app.post '/dashboard/category/add', authentication, category.add
	
	#dashboard category edit
	app.get '/dashboard/category/edit/:catename', authentication, category.edit
	
	#dashboard operator save
	app.post '/dashboard/category/save/:catename', authentication, category.save
	
	#dashboard category delete
	app.get '/dashboard/category/delete/:catename', authentication, category.delete

	###################
	# content
	###################

	#dashboard add new content
	app.get '/dashboard/content/new', authentication, content.new

	#dashboard add new content
	app.post '/dashboard/content/add', authentication, content.add

	#dashboard edt content
	app.get '/dashboard/content/edit/:uid', authentication, content.edit

	#dashboard save content
	app.post '/dashboard/content/save/:uid', authentication, content.save

	#dashboard cancel content
	app.get '/dashboard/content/cancel', authentication, content.cancel

	#dashboard delete content
	app.get '/dashboard/content/delete/:uid', authentication, content.delete

	#dashboard checkunique content
	app.get '/dashboard/content/checkunique/:url', authentication, content.checkunique

	###################
	# admin
	###################
	
	#dashboard admin save( userinfo )
	app.post '/dashboard/admin/profile/:username', authentication, admin.profile
	
	#dashboard admin update( userinfo )
	app.get '/admin-profile', authentication, admin.updateprofile

	###################
	# 404
	###################

	#404 error
	app.get '/404', ( req, res ) ->
		console.log '-- 404 -- '
		res.render '404'
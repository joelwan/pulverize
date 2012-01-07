$config = {
  'extensions'  => {},
  'cssPath'     => "",
  "jsPath" => "",
  'css'         => {},
  'js'     => {},
  'yui_options' => '--preserve-semi'
}

$config['cssPath'] = 'css'
$config['jsPath'] = 'scripts'

$config['extensions'] = [
  '.html',
  '.htm',
  '.php' 
]

$config['css'] = {
  'all' => [
    '/css/style1.css',
    '/css/style2.css',
    '/css/style3.css'
    ]
}

$config['js'] = {
  'all' => [
    '/scripts/script1.js',
    '/scripts/script2.js',
    '/scripts/script3.js'
  ]
}
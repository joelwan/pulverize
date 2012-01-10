$config = {
  'pulverize' => {
      'extensions'  => {},
      'cssPath'     => "",
      "jsPath" => "",
      'css'         => {},
      'js'     => {},
      'yui_options' => '--preserve-semi'
    }
}

$config['pulverize']['cssPath'] = 'css'
$config['pulverize']['jsPath'] = 'scripts'

$config['pulverize']['extensions'] = [
  '.html',
  '.htm',
  '.php' 
]

$config['pulverize']['css'] = {
  'all' => [
    '/css/style1.css',
    '/css/style2.css',
    '/css/style3.css'
    ]
}

$config['pulverize']['js'] = {
  'all' => [
    '/scripts/script1.js',
    '/scripts/script2.js',
    '/scripts/script3.js'
  ]
}
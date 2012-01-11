#generic config object
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

#location where the combined and minified scripts are generated
$config['pulverize']['cssPath'] = 'css'
$config['pulverize']['jsPath'] = 'scripts'

#file extensions to parse
$config['pulverize']['extensions'] = [
  '.html',
  '.htm',
  '.php' 
]

#css combinations
$config['pulverize']['css'] = {
  'all' => [
    '/css/style1.css',
    '/css/style2.css',
    '/css/style3.css'
    ]
}

#js combinations
$config['pulverize']['js'] = {
  'all' => [
    '/scripts/script1.js',
    '/scripts/script2.js',
    '/scripts/script3.js'
  ]
}
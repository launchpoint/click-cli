#!/usr/bin/php
<?

function create_app()
{
  global $argv;
  
  $dir = array_shift($argv);
  
  $fpath = getcwd()."/{$dir}";
  
  if(file_exists($dir))
  {
    die("Can't create app, folder already exists: {$dir}");
  }
  system("git clone git://github.com/launchpoint/clickcore.git $dir");
  $s = file_get_contents($fpath."/vhost.conf.template");
  $s = preg_replace("/#path#/", $fpath, $s);
  file_put_contents($fpath."/vhost.conf", $s);
  system("sudo chown lsi:www-data -R $dir");
  die("Application created. Browse to the base URL to continue configuration.");
}

function gitify()
{
  global $argv;
  $github_account_name = array_shift($argv);
  $n = "click-".basename(getcwd());
  echo "Go to github and create a project named {$n}\n";
  echo "\n============\n";
  echo <<<GITIFY
touch README.md
git init
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:{$github_account_name}/{$n}.git
git push -u origin master

GITIFY;
}

array_shift($argv);
$command = trim(strtolower(array_shift($argv)));

switch($command)
{
  case 'create':
    create_app();
    break;
  case 'gitify':
    gitify();
    break;
  default:
    die("Command {$command} unknown.");
}


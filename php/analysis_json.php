<?php
$json = '{"a":1,"b":2,"c":3,"d":4,"e":5}';
$a = json_decode($json);
#解析后变为对象，可用对象方法取其值：
echo "a in b is:" . $a -> b;

#PHP数组转对象：

function array2object($array) {
  if (is_array($array)) {
    $obj = new StdClass();
    foreach ($array as $key => $val){
      $obj->$key = $val;
    }
  }
  else { $obj = $array; }
  return $obj;
}


#PHP中对象转数组：
function object2array($object) {
  if (is_object($object)) {
    foreach ($object as $key => $value) {
      $array[$key] = $value;
    }
  }
  else {
    $array = $object;
  }
  return $array;
}

?>

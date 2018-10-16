<?php

function response($s,$c,$r)
{
	$response = array ('Status' => $s, 'Code' => $c, 'Result' => $r);
	header('Content-Type: application/json');
	echo json_encode($response);
}

function diff($a,$b)
{
	$res = $a - $b;
	return $res;
}

$pa = $_GET["a"];
$pb = $_GET["b"];

$status = 'OK';
$result = 0;
$code = 0;

if (empty($pa)) {
	$status = "param A is missing!";
	$code = 1;
	response($status,$code,$result);
	exit;
}

if (empty($pb)) {
	$status = "param B is missing!";
	$code = 2;
	response($status, $code, $result);
	exit;
}


if (!is_numeric($pa)) {
	$status = "param A is not a number!";
	$code = 3;
	response($status, $code, $result);
	exit;
}

if (!is_numeric($pb)) {
	$status = "param A is not a number!";
	$code = 4;
	response($status, $code, $result);
	exit;
}

$pa = $pa + 0;
$pb = $pb + 0;

if (!is_int($pa)) {
	$status = "param A is not integer!";
	$code = 5;
	response($status, $code, $result);
	exit;
}

if (!is_int($pb)) {
	$status = "param B is not integer!";
	$code = 6;
	response($status, $code, $result);
	exit;
}

if ($code == 0) {
	$result = diff($pa, $pb);
	response($status, $code, $result);
	exit;
}

?>

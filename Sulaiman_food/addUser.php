<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {

		$sqlUserid = "SELECT MAX(User_id)AS UserID FROM userTABLE";
		$result = $link->query($sqlUserid);
                if($result->num_rows > 0) {
                    while($rs = $result->fetch_assoc()) {
                       
						$id = substr($rs['UserID'], -3);
						if($id==""){
							$nextUserId ="U00001";
						}else{
						$userid = ($id + 1);
						$maxId = substr("U0000".$userid, -3);
                        $nextUserId = "U00".$maxId;
						}

		
					}
				}
		
		$chooseType = $_GET['chooseType'];		
		$name = $_GET['name'];
		$user = $_GET['user'];
		$password = $_GET['password'];
		
		
							
		$sql = "INSERT INTO `userTABLE`(`User_id`,`ChooseType`, `Name`, `User`, `Password`, `Token`) VALUES ('$nextUserId','$chooseType','$name','$user','$password','')";
		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		// $sql2 = "INSERT INTO infomationShop(User_id)values
		// ('$nextUserId')";
		// $result2 = mysqli_query($link, $sql2);

		} else {
			echo "false";
		}

	} else echo "Welcome Sulaiman Food";
   
}
	mysqli_close($link);
?>
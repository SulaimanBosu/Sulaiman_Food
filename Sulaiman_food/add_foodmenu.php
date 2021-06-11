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

				$sqlFoodid = "SELECT MAX(Food_id)AS FoodID FROM foodMenu";
		$_result = $link->query($sqlFoodid);
                if($_result->num_rows > 0) {
                    while($rs = $_result->fetch_assoc()) {
                       
						$id = substr($rs['FoodID'], -3);
						if($id==""){
							$nextFoodId ="F00001";
						}else{
						$foodid = ($id + 1);
						$maxId = substr("F0000".$foodid, -3);
                        $nextFoodId = "F00".$maxId;
						}

		
					}
				}
			
				
		$FoodName = $_GET['foodname'];
		$FoodDetail = $_GET['fooddetail'];
		$Price = $_GET['price'];
		$Urlimage = $_GET['urlImage'];
		$Userid = $_GET['userid'];
		//$Shopid = $_GET['Shopid'];

	$_result = mysqli_query($link, "SELECT Shop_id FROM infomationShop WHERE User_id = '$Userid'");
	$row = mysqli_fetch_array($_result);
	$Shopid = $row['Shop_id'];
	
							
		if($Shopid == '' || $Shopid == Null){

		    echo "noShop";
			//echo '[{"Shop_id":"null"}]';

		}else{

		$sql = "INSERT INTO foodMenu(Food_id,Food_Name,Food_Detail,Price,Image_Path,Shop_id,User_id)values
	('$nextFoodId','$FoodName','$FoodDetail','$Price','$Urlimage','$Shopid','$Userid')";


		$result = mysqli_query($link, $sql);

		if ($result){
			echo "true";
		} else {
			echo "false";
		}
	  }

	} else echo "Welcome Sulaiman Food";
   
}

	mysqli_close($link);
?>
<?php
    $body = file_get_contents('php://input');
    echo "\n\nfrom \$body\n";
    print($body);
    
    echo "\n\nfrom \$_GET\n";
    print_r($_GET?:[]);

    echo "\n\nfrom \$_POST\n";
    print_r($_POST?:[]);
    

    echo "\n\nfrom \$_FILES\n";
    print_r($_FILES?:[]);
    
    
?>


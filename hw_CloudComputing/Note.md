## download project locally
scp -r -P 11022 rui@localhost:/home/rui/HWphoto/ E:\vmShenanigans\CloudComputing\hw_CloudComputing
## upload project locally
ssh rui@localhost -p 11022 "rm -rf /home/rui/HWphoto/*";
scp -r -P 11022 E:\vmShenanigans\CloudComputing\hw_CloudComputing\HWphoto rui@localhost:/home/rui/

## upload myapp
scp -r -P 11022  E:\vmShenanigans\CloudComputing\hw_CloudComputing\HWphoto\web\myapp rui@localhost:/home/rui/HWphoto/web/

ssh rui@localhost -p 11022 "rm -rf /home/rui/HWphoto/*"

## todo
-  read assignment
- web Dockerfile, volume to myapp/ turn into copy


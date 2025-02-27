# Part 7. Prometheus и Grafana
<hr>
Grafana port 3000 
![](https://github.com/jarmenyu/DO4_LinuxMonitoring-v2.0/blob/main/src/07/screen/1.png) 
Prometheus port 9090 
![](screen/2.png) 
Добавить на дашборд Grafana отображение ЦПУ, доступной оперативной памяти, свободное место и кол-во операций ввода/вывода на жестком диске 
![33](screen/33.png) 
Запустить ваш bash-скрипт из part2 
Посмотреть на нагрузку жесткого диска (место на диске и операции чтения/записи) 
![3](./screen/3.png) 
![4](./screen/4.png) 
Посмотреть на нагрузку жесткого диска, оперативной памяти и ЦПУ stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s 
![5](./screen/5.png) 
![6](./screen/6.png) 
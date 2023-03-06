USE  examenparcial1;
select * from centros;
select * from departamentos;
select * from empleados;

SELECT e.NOMDE 
FROM DEPARTAMENTOS as e
WHERE TIDIR = 'F'
ORDER BY NOMDE asc;

/*3. Obtener salario y nombre de los empleados sin hijos y cuyo salario es mayor que 
1200 y menor que 1500 €. Se obtendrán por orden decreciente de salario y por 
orden alfabético dentro de salario*/
select e.SALAR, e.NOMEM
from empleados as e 
where e.SALAR >=1200 and 
e.SALAR<= 1500
order by e.SALAR desc, e.NOMEM asc;

/*4. Obtener una relación por orden alfabético de los departamentos cuyo presupuesto 
es inferior a 30.000 € El nombre de los departamentos vendrá precedido de las 
palabras “DEPARTAMENTO DE “. Nota: El presupuesto de los departamentos 
viene expresado en miles de €*/
SELECT d.NOMDE as 'DEPARTAMENTO DE', d.PRESU
FROM departamentos as d
WHERE d.PRESU < 30
ORDER BY d.NOMDE asc

/*5. Muestra el número y el nombre de cada departamento separados por un guión y 
en un mismo campo llamado “Número-Nombre”, además del tipo de director 
mostrado como “Tipo de Director”, para aquellos departamentos con presupuesto 
inferior a 30.000 €.*/

SELECT CONCAT(d.NUMDE ,'-', d.NOMDE) as 'Numero-Nombre', d.TIDIR as 'Tipo de Director'
FROM departamentos as d
WHERE d.PRESU < 30

/*6. Para los empleados del departamento 112 hallar el nombre y el salario total 
(salario más comisión), por orden de salario total decreciente, y por orden 
alfabético dentro de salario total*/
SELECT e.NOMEM as 'Empleado', SUM(COALESCE(e.SALAR,0) + COALESCE(e.COMIS,0)) as 'Salario Total'
FROM empleados as e 
WHERE e.NUMDE = 112
GROUP BY e.NOMEM
ORDER BY 'Salario Total' desc, 'Empleado' asc;

/*7. Obtener por orden alfabético los nombres y salarios de los empleados con 
comisión, cuyo salario dividido por su número de hijos cumpla una, o ambas, de 
las dos condiciones siguientes:
• Que sea inferior de 720 €
• Que sea superior a 50 veces su comisión.*/
SELECT e.NOMEM, e.SALAR
FROM empleados as e 
WHERE e.SALAR/e.NUMHI < 720 
OR e.SALAR/e.NUMHI > e.COMIS*50
ORDER BY e.NOMEM asc;

/*8. Obtener por orden alfabético los nombres y el presupuesto de los departamentos 
que incluyen la palabra “SECTOR”. La consulta la deberás mostrar como la 
imagen.*/
SELECT d.NOMDE, d.PRESU
FROM departamentos as d
WHERE d.NOMDE LIKE '%SECTOR%'
ORDER BY d.NOMDE asc;

/*9. Obtener por orden alfabético los nombres de los empleados que trabajan en el 
mismo departamento que PILAR o DOROTEA.*/
SELECT e.NOMEM
FROM empleados as e
WHERE e.NUMDE IN (SELECT NUMDE FROM empleados WHERE NOMEM IN ('PILAR','DOROTEA'));

/*10. Obtener por orden alfabético, los nombres y fechas de nacimiento de los 
empleados que cumplen años en el mes de noviembre.*/
SELECT e.NOMEM, e.FECNA
FROM empleados as e 
WHERE MONTH(e.FECNA)=9;

/*11.Obtener por orden alfabético los salarios y nombres de los empleados tales que 
su salario más un 40% supera al máximo salario.*/
SELECT e.NOMEM, e.SALAR
FROM empleados as e 
WHERE e.SALAR > (SELECT MAX(SALAR) FROM empleados)*0.40
ORDER BY e.NOMEM asc;

/*12.Hallar el número de empleados que usan la misma extensión telefónica. 
Solamente se desea mostrar aquellos grupos que tienen más de 1 empleado.*/

SELECT e.EXTEL,COUNT(e.NUMEM) as 'Recuento de empleados'
FROM empleados as e
GROUP BY e.EXTEL
HAVING COUNT(e.NUMEM) > 1;

/*13.Para cada departamento con presupuesto inferior a 35.000 €, hallar le nombre del 
Centro donde está ubicado y el máximo salario de sus empleados (si dicho 
máximo excede de 1.500 €). Clasificar alfabéticamente por nombre de 
departamento. Recuerde que el presupuesto está almacenado en miles.*/
SELECT d.NOMDE, d.PRESU, c.NOMCE, MAX(e.SALAR)
FROM departamentos as d INNER JOIN
empleados as e ON d.NUMDE = e.NUMDE
INNER JOIN centros as c 
ON d.NUMCE = c.NUMCE
GROUP BY d.NOMDE, d.PRESU, c.NOMCE
HAVING  MAX(e.SALAR) >1500 AND MAX(d.PRESU) < 35 ;

/*14.Obtener los nombres y los salarios medios de los departamentos cuyo salario 
medio supera al salario medio de la empresa.*/
SELECT d.NOMDE, AVG(e.SALAR) as 'Salario Medio'
FROM departamentos as d 
INNER JOIN empleados as e 
ON d.NUMDE = e.NUMDE
GROUP BY d.NOMDE
HAVING AVG(e.SALAR) > (SELECT AVG(SALAR) from empleados);

/*15.Para los departamentos cuyo director lo sea en funciones, hallar el número de 
empleados y la suma de sus salarios, comisiones y número de hijos.*/
SELECT d.NOMDE, COUNT(COALESCE(e.NUMEM,0)) as 'No. Empleados', SUM(COALESCE(e.SALAR,0)) as 'Suma Salarios', SUM(COALESCE(e.COMIS,0)) as 'Suma Comisiones', SUM(COALESCE(e.NUMHI,0)) as 'No de Hijos'
FROM departamentos as d 
INNER JOIN empleados as e ON 
d.NUMDE = e.NUMDE
WHERE d.TIDIR='F'
GROUP BY d.NOMDE;

/*16.Hallar el máximo valor de la suma de los salarios de los departamentos.*/
SELECT d.NOMDE as 'Depto', SUM(e.SALAR) as 'Salario'
FROM departamentos d
INNER JOIN empleados e ON d.NUMDE = e.NUMDE
GROUP BY d.NOMDE
HAVING SUM(e.salar) >= ALL(SELECT SUM(SALAR) FROM empleados GROUP BY NUMDE);



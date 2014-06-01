delete
FROM `objects`
where class like '%chestb%' or class like '%faceh%' or name like '%hatch%';


delete
FROM `objects`
where obj_id in (61322,61364);

SELECT obj_id,class,name,material, replace(material,'|of','')
FROM `objects`
where material like '%|of%';


update objects set material = replace(material,'|of','')
where material like '%|of%';

update objects set material = replace(material,'|Of','')
where material like '%|of%';

SELECT obj_id,class,name,material, replace(material,'of|','')
FROM `objects`
where material like '%of|%';


SELECT obj_id,class,name,material, replace(material,'|and|','|')
FROM `objects`
where material like '%|and|%';


update objects set material = replace(material,'|and|','|')
where material like '%|and|%';

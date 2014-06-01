use wolispac_cow;

#select a.obj_id,left(a.class,15),a.name,a.link,b.obj_id,left(b.class,15),b.name,b.link from objects as a left join objects as b on a.link = b.obj_id where a.link > 0 and b.obj_id is null;

select a.obj_id,left(a.class,15),a.name,a.loc,b.obj_id,left(b.class,15),b.name,b.loc from objects as a left join objects as b on a.loc = b.obj_id where a.loc > 0 and b.obj_id is null;



#select a.obj_id,left(a.class,15),a.name,a.link,b.obj_id,left(b.class,15),b.name,b.link from objects as a inner join objects as b on a.link = b.obj_id;
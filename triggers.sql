--triggers
-- If the share for all musicians associated with an artist does not sum to 1.0 an error message should be printed (using RAISERROR)
drop trigger sumtoone
create trigger sumtoone on Plays after insert-
as 
if exists (
  select top 1 null
  from (
    select sum(share) as SUMM
    from Plays p inner join Artist a on a.artistname=p.artistname
    where a.artistname= (select artistname from inserted)) t
  where t.SUMM > 1
)
BEGIN
    RAISERROR ('Sum of shares cannot be greater than 1',16, 1)
END

if exists (
  select top 1 null
  from (
    select sum(share) as SUMM
    from Plays p inner join Artist a on a.artistname=p.artistname
    where a.artistname= (select artistname from inserted)) t
  where t.SUMM <> 1
)
BEGIN
    RAISERROR ('Sum of shares has to be equal to 1',16, 1)
END

--triggers
--The members attribute of the Artist table should always equal the number of musicians who are members of the artist. 

drop trigger members_insert
create trigger members_insert on Plays after insert
as
begin
  update Artist set members = ins.newMem from
  (select a.artistname, a.members + count(msin) as newMem
  from Artist a inner join inserted i on a.artistname = i.artistname
  group by a.artistname, a.members) as ins   
  where Artist.artistname = ins.artistname 
end


drop trigger members_update
create trigger members_update on Plays for update
as
begin
  update Artist set members = ins.newMem from
  (select a.artistname, a.members + count(msin) as newMem
  from Artist a inner join inserted i on a.artistname = i.artistname
  group by a.artistname, a.members) as ins   
  where Artist.artistname = ins.artistname 

  update Artist set members = ins.newMem from
  (select a.artistname, a.members - count(msin) as newMem
  from Artist a inner join deleted i on a.artistname = i.artistname
  group by a.artistname, a.members) as ins   
  where Artist.artistname = ins.artistname --right? include two begin/ends?
end



drop trigger members_delete
create trigger members_delete on Plays after delete
as
begin
  update Artist set members = ins.newMem from
  (select a.artistname, a.members - count(msin) as newMem
  from Artist a inner join deleted i on a.artistname = i.artistname
  group by a.artistname, a.members) as ins   
  where Artist.artistname = ins.artistname
end

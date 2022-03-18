/* Q17. Information propagation analysis
\set tag '\'Slavoj_Žižek\''
\set delta '4'
 */
SELECT Message1.CreatorPersonId AS "person1.id", count(Message2.MessageId) AS messageCount
FROM Tag
-- (tag)<-[:HAS_TAG]-(message1)
JOIN Message_hasTag_Tag Message1_hasTag_Tag
  ON Message1_hasTag_Tag.TagId = Tag.id
JOIN MessageThread Message1
  ON Message1.MessageId = Message1_hasTag_Tag.MessageId
-- (message1)-[:REPLY_OF*0..]->(post1)
JOIN MessageThread MessageThread1
  ON MessageThread1.MessageId = Message1.MessageId
JOIN Post Post1
  ON Post1.id = MessageThread1.RootPostId
-- (tag)<-[:HAS_TAG]-(message2)
JOIN Message_hasTag_Tag Message2_hasTag_Tag
  ON Message2_hasTag_Tag.TagId = Tag.id
-- (message2 <date filtering>})
JOIN MessageThread Message2
  ON Message2.MessageId = Message2_hasTag_Tag.MessageId
 AND (Message1.creationDate + ':delta hour'::interval) < Message2.creationDate
JOIN Comment_hasTag_Tag
  ON Comment_hasTag_Tag.TagId = Tag.id
-- (comment)-[:REPLY_OF]->(message)
JOIN Comment
  ON Comment.id = Comment_hasTag_Tag.CommentId
 AND coalesce(Comment.ParentPostId, Comment.ParentCommentId) = Message2.MessageId
-- (message)-[:REPLY_OF*0..]-(post2)
JOIN MessageThread MessageThread2
  ON MessageThread2.MessageId = Message2.MessageId
JOIN Post Post2
  ON Post2.id = MessageThread2.RootPostId
 AND Post2.ContainerForumId != Post1.ContainerForumId -- forum2 != forum1
-- NOT (forum2)-[:HAS_MEMBER]->(person1)
LEFT JOIN Forum_hasMember_Person Forum_hasMember_Person1
  ON Forum_hasMember_Person1.ForumId = Post2.ContainerForumId -- forum2
 AND Forum_hasMember_Person1.PersonId = Message1.CreatorPersonId -- person1
-- (forum1)-[:Has_MEMBER]->(person2)
JOIN Forum_hasMember_Person Forum_hasMember_Person2
  ON Forum_hasMember_Person2.ForumId = Post1.ContainerForumId -- forum1
 AND Forum_hasMember_Person2.PersonId = Comment.CreatorPersonId -- person2
-- (forum1)-[:Has_MEMBER]->(person3)
JOIN Forum_hasMember_Person Forum_hasMember_Person3
  ON Forum_hasMember_Person3.ForumId = Post1.ContainerForumId -- forum1
 AND Forum_hasMember_Person3.PersonId = Message2.CreatorPersonId -- person3
WHERE Tag.name = :tag
  AND Forum_hasMember_Person1.ForumId IS NULL
GROUP BY Message1.CreatorPersonId
ORDER BY messageCount, Message1.CreatorPersonId
LIMIT 10
;

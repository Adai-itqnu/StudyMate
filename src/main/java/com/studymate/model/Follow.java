package com.studymate.model;

import java.util.Date;

public class Follow {
    private int followerId;
    private int followeeId;
    private Date createdAt;

    public Follow() {}

    // getters và setters
    public int getFollowerId() { return followerId; }
    public void setFollowerId(int followerId) { this.followerId = followerId; }
    public int getFolloweeId() { return followeeId; }
    public void setFolloweeId(int followeeId) { this.followeeId = followeeId; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}

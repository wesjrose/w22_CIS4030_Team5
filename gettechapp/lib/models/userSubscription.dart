class UserSubscription {
  String userId;
  String productId;

  UserSubscription( this.userId, this.productId);

  Map<String, dynamic> toJson(){
    return {
      'SubscribedItem': productId,
      'User': userId,
    };
  }

}
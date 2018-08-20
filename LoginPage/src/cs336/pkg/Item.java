package cs336.pkg;

public class Item {
	
	private String ItemName;
	private String ItemType;
	private int  ItemID;
	
	public Item(int ItemID ,String ItemName, String ItemType) {
		
		this.ItemID = ItemID;
		this.ItemName = ItemName;
		this.ItemType = ItemType;
	}
	
	public void setItemID(int itemID) {
		ItemID = itemID;
	}
	public int getItemID() {
		return ItemID;
	}
	
	public void setItemName(String itemName) {
		ItemName = itemName;
	}
	public String getItemName() {
		return ItemName;
	}
	public void setItemType(String itemType) {
		ItemType = itemType;
	}
	public String getItemType() {
		return ItemType;
	}

}

package org.acme.quickstart.entity.special;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "special_items")
public class SpecialItem extends PanacheEntityBase {
    @Id
    private Integer id;
    private String special_name;

    @Override
    public String toString() {
        return "Item{" +
                "id=" + id +
                ", name='" + special_name + '\'' +
                '}';
    }
}

package org.acme.quickstart.resource;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import org.acme.quickstart.entity.normal.Item;
import org.acme.quickstart.entity.special.SpecialItem;

import java.util.List;

@Path("/")
public class GreetingResource {

    @GET
    @Path("/items")
    @Produces(MediaType.TEXT_PLAIN)
    public List<Item> hello() {
        return Item.listAll();
    }

    @GET
    @Path("/specialItems")
    @Produces(MediaType.TEXT_PLAIN)
    public List<Item> getItems() {
        return SpecialItem.listAll();
    }

}
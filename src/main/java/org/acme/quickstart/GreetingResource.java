package org.acme.quickstart;

import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.List;

@Path("/hello")
public class GreetingResource {

    @Inject
    EntityManager em;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public List<Item> hello() {
        return getItems();
    }

    @Transactional
    public List<Item> getItems() {
        return (List<Item>) em.createQuery("select i from Item i").getResultList();
    }

}
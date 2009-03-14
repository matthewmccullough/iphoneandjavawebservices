/**
 * Document me.
 * <br>
 * User: Matthew McCullough, matthewm@ambientideas.com
 * Date: Nov 10, 2008
 */
package com.ambientideas.iphone;

import com.sun.net.httpserver.HttpServer;
import com.sun.jersey.api.container.httpserver.HttpServerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.ws.rs.*;

// JSR 311 used for Restful annotations (JAX-RS: Java API for RESTful Web Services)
// Useful info about @PathParam and its patterns at
// http://www.jboss.org/file-access/default/members/resteasy/freezone/docs/1.0-beta-6/userguide/html/@PathParam.html

@Path("/drawing")
public class ContestantDrawing {
    static List<String> contestants = new ArrayList();
    static Random rand = new Random();

    /**
     * Get a random winner from the list of current contestants
     *
     * @return Contestant's name
     */
    @GET
    @Produces("text/plain")
    public String getWinner() throws InterruptedException {
        String randomContestantName = null;

        if (contestants.isEmpty()) {
            randomContestantName = "NO CONTESTANTS";
        } else {

            //Randomly select a winner
            int randomContestantPosition = Math.abs((rand.nextInt()) % (contestants.size()));
            System.out.println("Randomly retriving contestant position: " + randomContestantPosition);

            randomContestantName = contestants.get(randomContestantPosition);
        }

        System.out.println("Randomly retriving contestant: " + randomContestantName);

        Thread.sleep(3000);

        return randomContestantName;
    }

    /**
     * Add a new contestant
     * 
     * @param contestantName The new contestant
     */
    @PUT
    @Path("/{name}")
    @Consumes("text/plain")
    public String addContestant(@PathParam("name") String contestantName) throws InterruptedException {
        System.out.println("Adding contestant: " + contestantName);
        contestants.add(contestantName);

        Thread.sleep(3000);

        return contestantName;
    }

    /**
     * A barebones main that can run the service with no container via the Jersey component of Glassfish
     */

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServerFactory.create("http://localhost:9090/");
        server.start();

        System.out.println("Server running");
        System.out.println("Visit: http://localhost:9090/drawing");
        System.out.println("Hit return to stop...");
        System.in.read();
        System.out.println("Stopping server");
        server.stop(0);
        System.out.println("Server stopped");
    }
}
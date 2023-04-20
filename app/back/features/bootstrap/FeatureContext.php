<?php

namespace App\Tests;

use App\Kernel;
use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\KernelInterface;

/**
 * Defines application features from the specific context.
 */
class FeatureContext implements Context
{
    private Kernel $kernel;

    private Response $tmpResp;

    public function __construct(Kernel $kernel)
    {
        $this->kernel = $kernel;
    }

    /**
     * @When je me rends sur :path
     */
    public function jeMeRendsSur(string $path)
    {
        dump($_ENV);
        $this->tmpResp = $this->kernel->handle(Request::createFromGlobals());
        $this->kernel->shutdown();
    }

    /**
     * @Then je vois toutes les cartes bancaires
     */
    public function jeVoisToutesLesCartes()
    {
        dump($this->tmpResp);
    }
}
